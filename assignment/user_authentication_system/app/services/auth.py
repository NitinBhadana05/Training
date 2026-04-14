from dataclasses import dataclass

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.security import (
    create_access_token,
    create_reset_token,
    decode_token,
    hash_password,
    verify_password,
)
from app.models.user import User
from app.schemas.auth import (
    ForgotPasswordRequest,
    LoginRequest,
    ResetPasswordRequest,
    SignupRequest,
)


class AuthRedirectException(Exception):
    def __init__(self, redirect_to: str) -> None:
        self.redirect_to = redirect_to
        super().__init__(redirect_to)


@dataclass
class ResetPasswordResult:
    token: str | None
    email: str | None


def get_user_by_email(db: Session, email: str) -> User | None:
    statement = select(User).where(User.email == email.lower())
    return db.execute(statement).scalar_one_or_none()


def create_user(db: Session, payload: SignupRequest) -> User:
    normalized_email = payload.email.lower()
    existing_user = get_user_by_email(db, normalized_email)
    if existing_user:
        raise ValueError("An account with this email already exists.")
    if payload.password != payload.confirm_password:
        raise ValueError("Passwords do not match.")

    user = User(
        name=payload.name.strip(),
        email=normalized_email,
        hashed_password=hash_password(payload.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def authenticate_user(db: Session, payload: LoginRequest) -> User:
    user = get_user_by_email(db, payload.email)
    if not user or not verify_password(payload.password, user.hashed_password):
        raise ValueError("Invalid email or password.")
    return user


def issue_access_token(user: User) -> str:
    return create_access_token(subject=str(user.id))


def get_current_user_from_token(db: Session, token: str | None) -> User:
    if not token:
        raise AuthRedirectException("/login?error=Please+log+in+to+continue.")

    payload = decode_token(token)
    if not payload or payload.token_type != "access":
        raise AuthRedirectException("/login?error=Your+session+is+invalid+or+expired.")

    user = db.get(User, int(payload.sub))
    if not user:
        raise AuthRedirectException("/login?error=Account+not+found.")
    return user


def create_password_reset_request(
    db: Session, payload: ForgotPasswordRequest
) -> ResetPasswordResult:
    user = get_user_by_email(db, payload.email)
    if not user:
        return ResetPasswordResult(token=None, email=None)
    return ResetPasswordResult(
        token=create_reset_token(subject=str(user.id)),
        email=user.email,
    )


def reset_password(db: Session, token: str, payload: ResetPasswordRequest) -> None:
    if payload.password != payload.confirm_password:
        raise ValueError("Passwords do not match.")

    token_payload = decode_token(token)
    if not token_payload or token_payload.token_type != "reset":
        raise ValueError("Reset link is invalid or expired.")

    user = db.get(User, int(token_payload.sub))
    if not user:
        raise ValueError("User account not found.")

    user.hashed_password = hash_password(payload.password)
    db.add(user)
    db.commit()


def build_auth_cookie_settings() -> dict[str, object]:
    return {
        "key": settings.auth_cookie_name,
        "httponly": True,
        "secure": settings.app_env != "development",
        "samesite": "lax",
        "max_age": settings.access_token_expire_minutes * 60,
        "path": "/",
    }
