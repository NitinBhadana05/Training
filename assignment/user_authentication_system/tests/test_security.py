from app.core.security import (
    create_access_token,
    create_reset_token,
    decode_token,
    hash_password,
    verify_password,
)


def test_password_hashing_round_trip() -> None:
    password = "Secure@123"
    hashed = hash_password(password)

    assert hashed != password
    assert verify_password(password, hashed) is True
    assert verify_password("Wrong@123", hashed) is False


def test_access_token_contains_expected_claims() -> None:
    token = create_access_token("42")
    payload = decode_token(token)

    assert payload is not None
    assert payload.sub == "42"
    assert payload.token_type == "access"


def test_reset_token_uses_reset_type() -> None:
    token = create_reset_token("42")
    payload = decode_token(token)

    assert payload is not None
    assert payload.token_type == "reset"
