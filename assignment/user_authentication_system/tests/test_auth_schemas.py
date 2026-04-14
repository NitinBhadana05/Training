import pytest
from pydantic import ValidationError

from app.schemas.auth import ResetPasswordRequest, SignupRequest


def test_signup_request_accepts_valid_payload() -> None:
    payload = SignupRequest(
        name="Beryl Mason",
        email="beryl@example.com",
        password="Secure@123",
        confirm_password="Secure@123",
    )

    assert payload.name == "Beryl Mason"
    assert payload.email == "beryl@example.com"


@pytest.mark.parametrize(
    ("password", "message"),
    [
        ("short!", "at least 8 characters"),
        ("password123", "special character"),
    ],
)
def test_signup_request_rejects_weak_passwords(password: str, message: str) -> None:
    with pytest.raises(ValidationError) as exc_info:
        SignupRequest(
            name="Beryl Mason",
            email="beryl@example.com",
            password=password,
            confirm_password=password,
        )

    assert message in str(exc_info.value)


def test_reset_password_request_enforces_policy() -> None:
    with pytest.raises(ValidationError):
        ResetPasswordRequest(password="plainpassword", confirm_password="plainpassword")
