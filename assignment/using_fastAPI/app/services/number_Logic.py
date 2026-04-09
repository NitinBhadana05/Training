# ===== PRIME =====
def is_prime(n):
    if n <= 1:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


def get_primes(start, end):
    return [i for i in range(start, end + 1) if is_prime(i)]


# ===== FACTORIAL =====
def get_factorial(n):
    if n < 0:
        return None

    result = 1
    for i in range(1, n + 1):
        result *= i

    return result


# ===== FIBONACCI =====
def get_fibonacci(n):
    if n < 0:
        return []

    a, b = 0, 1
    series = []

    for _ in range(n):
        series.append(a)
        a, b = b, a + b

    return series


# ===== REVERSE =====
def reverse_number(n):
    return int(str(n)[::-1])


# ===== ARMSTRONG =====
def is_armstrong(n):
    digits = len(str(n))
    total = sum(int(d) ** digits for d in str(n))
    return "armstrong" if total == n else "not armstrong"


# ===== STRONG NUMBER =====
def is_strong(n):
    import math
    total = sum(math.factorial(int(d)) for d in str(n))
    return "strong" if total == n else "not strong"


# ===== ODD / EVEN =====
def check_even_odd(n):
    return "Even" if n % 2 == 0 else "Odd"