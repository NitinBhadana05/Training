def gcd(a: int, b: int) -> int:

    if a < 0:
        a = -a

    if b < 0:
        b = -b

    while b != 0:
        remainder = a % b
        a = b
        b = remainder

    return a


def lcm(a: int, b: int) -> int:

    if a == 0 or b == 0:
        return 0

    if a < 0:
        a = -a

    if b < 0:
        b = -b

    return (a * b) // gcd(a, b)


print (lcm(100, 8))

"""
Output: 200

"""


