def move_zeros_to_end(numbers: list[int]) -> None:

    if len(numbers) == 0:
        raise ValueError("Invalid list")

    insert_position: int = 0

    # Move non-zero elements forward
    for index in range(len(numbers)):
        if numbers[index] != 0:
            numbers[insert_position] = numbers[index]
            insert_position += 1

    # Fill remaining positions with zero
    for index in range(insert_position, len(numbers)):
        numbers[index] = 0


arr = [0,1,0,2,3,4]
move_zero_to_end(arr)


"""
Output: [1,2,3,4,0,0]

"""
