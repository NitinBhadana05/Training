def gcd(a: int, b: int) -> int:

    if a < 0:
        a = -a

    if b < 0:
        b = -b

    while b != 0:
        remainder: int = a % b
        a = b
        b = remainder

    return a


print (gcd(24,36))

"""
Output: 12

"""
