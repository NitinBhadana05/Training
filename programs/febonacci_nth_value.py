def fibonacci(n: int) -> int:

    if n < 0:
        raise ValueError("Invalid value")

    if n == 0:
        return 0

    if n == 1:
        return 1

    prev: int = 0
    curr: int = 1

    for _ in range(2, n + 1):
        next_value: int = prev + curr
        prev = curr
        curr = next_value

    return curr


print(fibonacci(5))

'''


Output: 5


'''
