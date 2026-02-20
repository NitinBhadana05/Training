def calculate_factorial(number: int) -> int:

    if number < 0:
        raise ValueError("Negative value not valid")

    fact: int = 1

    for i in range(1, number + 1):
        fact *= i

    return fact


def is_strong(number: int) -> bool:

    if number < 0:
        return False

    temp_number: int = number
    total_sum: int = 0

    while temp_number > 0:
        digit: int = temp_number % 10
        total_sum += calculate_factorial(digit)
        temp_number //= 10

    return total_sum == number

    
        
print(is_strong(145))


"""
Output

True
"""
