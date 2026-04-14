from datetime import UTC, datetime, timedelta

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings
from app.schemas.auth import TokenPayload


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def create_token(subject: str, token_type: str, expires_minutes: int) -> str:
    expire_at = datetime.now(UTC) + timedelta(minutes=expires_minutes)
    payload = {
        "sub": subject,
        "exp": expire_at,
        "token_type": token_type,
    }
    return jwt.encode(payload, settings.jwt_secret_key, algorithm=settings.jwt_algorithm)


def create_access_token(subject: str) -> str:
    return create_token(
        subject=subject,
        token_type="access",
        expires_minutes=settings.access_token_expire_minutes,
    )


def create_reset_token(subject: str) -> str:
    return create_token(
        subject=subject,
        token_type="reset",
        expires_minutes=settings.reset_token_expire_minutes,
    )


def decode_token(token: str) -> TokenPayload | None:
    try:
        payload = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm],
        )
        return TokenPayload.model_validate(payload)
    except JWTError:
        return None
