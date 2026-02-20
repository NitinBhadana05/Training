def remove_element(numbers: list[int], value: int) -> int:

    write_index: int = 0

    for read_index in range(len(numbers)):

        if numbers[read_index] != value:
            numbers[write_index] = numbers[read_index]
            write_index += 1

    return write_index


print(remove_element([1,2,3,4,3,4,4],4))
        

"""
Output: 4

"""
