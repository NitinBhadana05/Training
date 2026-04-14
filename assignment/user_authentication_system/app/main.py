from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.routes.web import router as web_router
from app.services.auth import AuthRedirectException

def create_application() -> FastAPI:
    app = FastAPI(
        title=settings.app_name,
        debug=settings.app_debug,
    )
    app.mount("/static", StaticFiles(directory="static"), name="static")
    app.include_router(web_router)

    @app.exception_handler(AuthRedirectException)
    async def auth_redirect_handler(
        _: Request, exc: AuthRedirectException
    ) -> RedirectResponse:
        return RedirectResponse(url=exc.redirect_to, status_code=303)

    @app.get("/health", tags=["health"])
    async def health_check() -> dict[str, str]:
        return {"status": "ok"}

    return app


app = create_application()
