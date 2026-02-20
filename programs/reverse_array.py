def reverse_array(numbers: list[int]) -> None:

    if len(numbers) == 0:
        raise ValueError("Empty list not allowed")

    left: int = 0
    right: int = len(numbers) - 1

    while left < right:
        temp: int = numbers[left]
        numbers[left] = numbers[right]
        numbers[right] = temp

        left += 1
        right -= 1

numbers = [1,2,3,4,5]
print(reverse_array(numbers))

"""

Output : [5,4,3,2,1]

"""
