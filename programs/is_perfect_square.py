def is_perfect_square(number: int) -> bool:

    if number < 0:
        return False

    i: int = 0

    while i * i <= number:

        if i * i == number:
            return True

        i += 1

    return False

print(is_perfect_square(1))

"""
Output: True

"""
