from app.services.email import build_password_reset_email


def test_build_password_reset_email_contains_reset_link() -> None:
    reset_link = "http://127.0.0.1:8000/reset-password?token=abc123"
    message = build_password_reset_email("beryl@example.com", reset_link)

    assert message["To"] == "beryl@example.com"
    assert message["Subject"] == "Reset your password"
    assert reset_link in message.as_string()
