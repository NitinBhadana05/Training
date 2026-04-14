from typing import Annotated

from fastapi import Cookie, Depends
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import get_db
from app.models.user import User
from app.services.auth import get_current_user_from_token


DbSession = Annotated[Session, Depends(get_db)]


def get_current_user(
    db: DbSession,
    access_token: Annotated[str | None, Cookie(alias=settings.auth_cookie_name)] = None,
) -> User:
    return get_current_user_from_token(db, access_token)


CurrentUser = Annotated[User, Depends(get_current_user)]
