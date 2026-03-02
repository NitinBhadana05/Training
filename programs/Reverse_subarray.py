def reverse_subarray(numbers: list[int], start: int, end: int) -> None:

    if start < 0 or end >= len(numbers) or start > end:
        raise ValueError("Invalid indices")

    left: int = start
    right: int = end

    while left < right:

        temp: int = numbers[left]
        numbers[left] = numbers[right]
        numbers[right] = temp

        left += 1
        right -= 1
Input:  [1,2,3,4,5,6]
start = 1
end = 4

print(reverse_subarray(input,start,end)
"""
Output: [1,5,4,3,2,6]
"""
