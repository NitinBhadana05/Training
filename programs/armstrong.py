def digit_count(number: int) -> int:

    if number == 0:
        return 1

    if number < 0:
        number = -number

    count: int = 0

    while number > 0:
        count += 1
        number //= 10

    return count


def calculate_power(base: int, exponent: int) -> int:

    result: int = 1
    counter: int = 0

    while counter < exponent:
        result *= base
        counter += 1

    return result


def is_armstrong(number: int) -> bool:

    if number < 0:
        return False

    digits: int = digit_count(number)

    temp_number: int = number
    total_sum: int = 0

    while temp_number > 0:
        digit: int = temp_number % 10
        total_sum += calculate_power(digit, digits)
        temp_number //= 10

    return total_sum == number

print(is_armstrong(121))

"""
Output

True
"""
