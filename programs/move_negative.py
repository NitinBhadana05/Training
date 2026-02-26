def move_negatives_left(numbers: list[int]) -> None:

    left: int = 0

    for right in range(len(numbers)):

        if numbers[right] < 0:

            temp: int = numbers[left]
            numbers[left] = numbers[right]
            numbers[right] = temp

            left += 1

    print(numbers)
move_negatives_left([1,-1,-2,3,4,-5,-6])
    
"""

Output : [-1, -2, -5, -6, 4, 1, 3]

"""
