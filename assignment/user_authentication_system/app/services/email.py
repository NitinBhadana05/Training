import smtplib
from email.message import EmailMessage

from app.core.config import settings


class EmailDeliveryError(Exception):
    """Raised when an application email could not be delivered."""


def build_password_reset_email(recipient_email: str, reset_link: str) -> EmailMessage:
    message = EmailMessage()
    message["Subject"] = "Reset your password"
    message["From"] = f"{settings.mail_from_name} <{settings.mail_from_email}>"
    message["To"] = recipient_email

    text_content = (
        "We received a request to reset your password.\n\n"
        f"Open this link to continue: {reset_link}\n\n"
        f"This link expires in {settings.reset_token_expire_minutes} minutes.\n"
        "If you did not request a password reset, you can ignore this email."
    )
    html_content = f"""
    <html>
        <body style="font-family: Arial, sans-serif; color: #1f2937; line-height: 1.6;">
            <p>We received a request to reset your password.</p>
            <p>
                <a href="{reset_link}" style="display:inline-block;padding:12px 20px;background:#1f2937;color:#ffffff;text-decoration:none;border-radius:10px;">
                    Reset password
                </a>
            </p>
            <p>If the button does not work, copy and paste this link into your browser:</p>
            <p>{reset_link}</p>
            <p>This link expires in {settings.reset_token_expire_minutes} minutes.</p>
            <p>If you did not request a password reset, you can ignore this email.</p>
        </body>
    </html>
    """

    message.set_content(text_content)
    message.add_alternative(html_content, subtype="html")
    return message


def send_email(message: EmailMessage) -> None:
    try:
        if settings.smtp_use_ssl:
            with smtplib.SMTP_SSL(settings.smtp_host, settings.smtp_port) as server:
                _login_if_configured(server)
                server.send_message(message)
            return

        with smtplib.SMTP(settings.smtp_host, settings.smtp_port) as server:
            server.ehlo()
            if settings.smtp_use_tls:
                server.starttls()
                server.ehlo()
            _login_if_configured(server)
            server.send_message(message)
    except OSError as exc:
        raise EmailDeliveryError("Unable to send password reset email.") from exc
    except smtplib.SMTPException as exc:
        raise EmailDeliveryError("Unable to send password reset email.") from exc


def send_password_reset_email(recipient_email: str, reset_link: str) -> None:
    message = build_password_reset_email(recipient_email, reset_link)
    send_email(message)


def _login_if_configured(server: smtplib.SMTP) -> None:
    if settings.smtp_username:
        server.login(settings.smtp_username, settings.smtp_password)
