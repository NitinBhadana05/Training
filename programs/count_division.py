def count_divisors(number: int) -> int:

    if number <= 0:
        raise ValueError("Invalid Number")

    count: int = 0

    for i in range(1, int(number**0.5) + 1):

        if number % i == 0:

            if i * i == number:
                count += 1
            else:
                count += 2

    return count
            
print(count_divisors(36))


"""
output:

9
"""
