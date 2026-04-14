from typing import Annotated
from urllib.parse import urlencode

from fastapi import APIRouter, Depends, Form, Request, status
from fastapi.responses import HTMLResponse, RedirectResponse, Response
from fastapi.templating import Jinja2Templates
from pydantic import ValidationError
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import get_db
from app.routes.dependencies import CurrentUser
from app.schemas.auth import ForgotPasswordRequest, LoginRequest, ResetPasswordRequest, SignupRequest
from app.services.auth import (
    build_auth_cookie_settings,
    create_password_reset_request,
    create_user,
    authenticate_user,
    issue_access_token,
    reset_password,
)
from app.services.email import EmailDeliveryError, send_password_reset_email


router = APIRouter()
templates = Jinja2Templates(directory="templates")

DbSession = Annotated[Session, Depends(get_db)]


def render_template(
    request: Request,
    template_name: str,
    context: dict | None = None,
    status_code: int = status.HTTP_200_OK,
) -> HTMLResponse:
    merged_context = {
        "request": request,
        "error": request.query_params.get("error"),
        "message": request.query_params.get("message"),
    }
    if context:
        merged_context.update(context)
    return templates.TemplateResponse(template_name, merged_context, status_code=status_code)


def redirect_with_params(path: str, **params: str) -> RedirectResponse:
    query = urlencode({key: value for key, value in params.items() if value})
    url = f"{path}?{query}" if query else path
    return RedirectResponse(url=url, status_code=status.HTTP_303_SEE_OTHER)


@router.get("/", response_class=HTMLResponse)
def root() -> RedirectResponse:
    return RedirectResponse(url="/login", status_code=status.HTTP_303_SEE_OTHER)


@router.get("/signup", response_class=HTMLResponse)
def signup_page(request: Request) -> HTMLResponse:
    return render_template(request, "signup.html")


@router.post("/signup", response_class=HTMLResponse, response_model=None)
def signup_submit(
    request: Request,
    db: DbSession,
    name: Annotated[str, Form(...)],
    email: Annotated[str, Form(...)],
    password: Annotated[str, Form(...)],
    confirm_password: Annotated[str, Form(...)],
) -> Response:
    try:
        payload = SignupRequest(
            name=name,
            email=email,
            password=password,
            confirm_password=confirm_password,
        )
        create_user(db, payload)
    except (ValidationError, ValueError) as exc:
        error_message = extract_error_message(exc)
        return render_template(
            request,
            "signup.html",
            {
                "error": error_message,
                "form_data": {"name": name, "email": email},
            },
            status.HTTP_400_BAD_REQUEST,
        )

    return redirect_with_params("/login", message="Account created successfully. Please sign in.")


@router.get("/login", response_class=HTMLResponse)
def login_page(request: Request) -> HTMLResponse:
    return render_template(request, "login.html")


@router.post("/login", response_class=HTMLResponse, response_model=None)
def login_submit(
    request: Request,
    db: DbSession,
    email: Annotated[str, Form(...)],
    password: Annotated[str, Form(...)],
) -> Response:
    try:
        payload = LoginRequest(email=email, password=password)
        user = authenticate_user(db, payload)
    except (ValidationError, ValueError) as exc:
        return render_template(
            request,
            "login.html",
            {
                "error": extract_error_message(exc),
                "form_data": {"email": email},
            },
            status.HTTP_400_BAD_REQUEST,
        )

    response = redirect_with_params("/dashboard", message="Welcome back.")
    response.set_cookie(value=issue_access_token(user), **build_auth_cookie_settings())
    return response


@router.post("/logout")
def logout() -> RedirectResponse:
    response = redirect_with_params("/login", message="You have been logged out.")
    response.delete_cookie(key=settings.auth_cookie_name, path="/")
    return response


@router.get("/forgot-password", response_class=HTMLResponse)
def forgot_password_page(request: Request) -> HTMLResponse:
    return render_template(request, "forgot_password.html")


@router.post("/forgot-password", response_class=HTMLResponse)
def forgot_password_submit(
    request: Request,
    db: DbSession,
    email: Annotated[str, Form(...)],
) -> HTMLResponse:
    try:
        payload = ForgotPasswordRequest(email=email)
        result = create_password_reset_request(db, payload)
    except ValidationError as exc:
        return render_template(
            request,
            "forgot_password.html",
            {
                "error": extract_error_message(exc),
                "form_data": {"email": email},
            },
            status.HTTP_400_BAD_REQUEST,
        )

    if result.token and result.email:
        reset_link = str(request.url_for("reset_password_page")) + f"?token={result.token}"
        try:
            send_password_reset_email(
                recipient_email=result.email,
                reset_link=reset_link,
            )
        except EmailDeliveryError as exc:
            return render_template(
                request,
                "forgot_password.html",
                {
                    "error": str(exc),
                    "form_data": {"email": email},
                },
                status.HTTP_502_BAD_GATEWAY,
            )

    return render_template(
        request,
        "forgot_password.html",
        {
            "message": "If that email exists, password reset instructions have been sent.",
        },
    )


@router.get("/reset-password", response_class=HTMLResponse)
def reset_password_page(request: Request, token: str = "") -> HTMLResponse:
    if not token:
        return render_template(
            request,
            "reset_password.html",
            {"error": "Reset token is missing."},
            status.HTTP_400_BAD_REQUEST,
        )
    return render_template(request, "reset_password.html", {"token": token})


@router.post("/reset-password", response_class=HTMLResponse, response_model=None)
def reset_password_submit(
    request: Request,
    db: DbSession,
    token: Annotated[str, Form(...)],
    password: Annotated[str, Form(...)],
    confirm_password: Annotated[str, Form(...)],
) -> Response:
    try:
        payload = ResetPasswordRequest(password=password, confirm_password=confirm_password)
        reset_password(db, token, payload)
    except (ValidationError, ValueError) as exc:
        return render_template(
            request,
            "reset_password.html",
            {
                "error": extract_error_message(exc),
                "token": token,
            },
            status.HTTP_400_BAD_REQUEST,
        )

    return redirect_with_params("/login", message="Password reset successfully. Please sign in.")


@router.get("/dashboard", response_class=HTMLResponse)
def dashboard_page(request: Request, user: CurrentUser) -> HTMLResponse:
    return render_template(request, "dashboard.html", {"user": user})


@router.get("/extra", response_class=HTMLResponse)
def extra_page(request: Request, user: CurrentUser) -> HTMLResponse:
    return render_template(request, "extra.html", {"user": user})


def extract_error_message(exc: ValidationError | ValueError) -> str:
    if isinstance(exc, ValidationError):
        first_error = exc.errors()[0]
        return str(first_error.get("msg", "Invalid input."))
    return str(exc)
