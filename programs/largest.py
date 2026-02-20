def find_largest(numbers: list[int]) -> int:

    if len(numbers) == 0:
        raise ValueError("List cannot be empty")

    largest: int = numbers[0]

    for index in range(1, len(numbers)):
        if numbers[index] > largest:
            largest = numbers[index]

    return largest

arr= [1,2,3,3,2,1,2]
print(find_largest(arr))


"""
Output: 3

"""
