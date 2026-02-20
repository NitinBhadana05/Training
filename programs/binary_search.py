def is_sorted(numbers: list[int]) -> bool:

    for index in range(len(numbers) - 1):
        if numbers[index] > numbers[index + 1]:
            return False

    return True

def binary_search(numbers: list[int], target: int) -> int:

    if len(numbers) == 0:
        return -1

    if not is_sorted(numbers):
        raise ValueError("Array must be sorted in ascending order")

    lower: int = 0
    upper: int = len(numbers) - 1

    while lower <= upper:

        mid: int = (lower + upper) // 2

        if numbers[mid] == target:
            return mid

        elif target > numbers[mid]:
            lower = mid + 1

        else:
            upper = mid - 1

    return -1

arr = [1,2,3,4,5]
print(binary_search(arr,4))
    
"""
Output: 3

"""
