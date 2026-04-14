# User Authentication System

Production-oriented FastAPI starter for a JWT-based authentication system with PostgreSQL, SQLAlchemy, and server-rendered HTML templates.

## Initial setup

1. Create a virtual environment.
2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Copy the environment file and update values:

   ```bash
   cp .env.example .env
   ```

4. Run the app:

   ```bash
   uvicorn app.main:app --reload
   ```

## SMTP setup

Configure these variables in `.env` to send password reset emails:

```bash
MAIL_FROM_EMAIL=no-reply@example.com
MAIL_FROM_NAME="User Authentication System"
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USERNAME=your-smtp-username
SMTP_PASSWORD=your-smtp-password
SMTP_USE_TLS=true
SMTP_USE_SSL=false
```

Use either `SMTP_USE_TLS=true` on port `587` or `SMTP_USE_SSL=true` on port `465`, not both.

## PostgreSQL with Docker

Start a local PostgreSQL instance:

```bash
docker compose up -d
```

The default `.env.example` database URL already matches this container.

## Database migrations

Run the initial migration after PostgreSQL is available:

```bash
alembic upgrade head
```

Create a future migration after model changes:

```bash
alembic revision --autogenerate -m "describe change"
```

## Tests

Run the current test suite with:

```bash
pytest
```

The test suite covers:

- Password validation rules
- Password hashing and JWT helpers
- Signup, login, logout, protected route redirects, and password reset flow

## Current scope

This first step includes:

- Project structure
- Environment-driven configuration
- PostgreSQL connection setup
- SQLAlchemy engine/session bootstrap
- Minimal FastAPI app with a health endpoint

## Implemented next

- User model with unique email constraint
- Signup, login, logout, forgot-password, and reset-password flows
- JWT session cookies for protected pages
- Dashboard and extra protected route
- Tailwind-based responsive templates
- Docker Compose PostgreSQL setup
- FastAPI dependency-based route protection
- Client-side validation aligned with backend rules
- Alembic migration setup with initial users table revision
- Basic tests for password validation and JWT/security helpers
- Integration tests for the full web authentication flow
- SMTP-based forgot-password email delivery
