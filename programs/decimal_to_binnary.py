def reverse_number(num: int) -> int:
    result: int = 0
    while num != 0:
        result = result * 10 + num % 10
        num //= 10
    return result


def decimal_to_binary(number: int) -> int:

    if number < 0:
        raise ValueError("Invalid number")

    if number == 0:
        return 0

    temp: int = 0

    while number != 0:
        remainder = number % 2
        temp = temp * 10 + remainder
        number //= 2

    return reverse_number(temp)
print(decimal_to_binary(94))
    

"""
Output: 101111

"""
