

def reverse_number(number: int) -> int:
    """
    Reverse digits of a number.
    Handles negative numbers.
    """

    if number == 0:
        return 0

    is_negative: bool = False

    if number < 0:
        is_negative = True
        number = -number

    reversed_number: int = 0

    while number > 0:
        last_digit: int = number % 10
        reversed_number = reversed_number * 10 + last_digit
        number = number // 10

    if is_negative:
        reversed_number = -reversed_number

    return reversed_number


"""
Output

enter a number 234
reverse of  234 is 432


"""
