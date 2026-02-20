
def find_second_largest(numbers: list[int]) -> int:

    if len(numbers) < 2:
        raise ValueError("At least two elements required")

    largest: int = numbers[0]
    second_largest: int = None

    for index in range(1, len(numbers)):

        current: int = numbers[index]

        if current > largest:
            second_largest = largest
            largest = current

        elif current != largest:
            if second_largest is None or current > second_largest:
                second_largest = current

    if second_largest is None:
        raise ValueError("No distinct second largest element")

    return second_largest


arr= [1,2,3,3,2,1,2,4,4]
print(find_second_largest(arr))
        

"""
output

3
"""
