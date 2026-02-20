def remove_duplicates(numbers: list[int]) -> list[int]:

    if len(numbers) == 0:
        raise ValueError("Empty list not valid")

    result: list[int] = []

    for index in range(len(numbers)):

        current: int = numbers[index]
        is_duplicate: bool = False

        for existing in result:
            if current == existing:
                is_duplicate = True
                break

        if not is_duplicate:
            result.append(current)

    return result

    
arr = [1,2,2,3,3,4,5]
print(remove_duplicate(arr))


"""
Output

[1,2,3,4,5]

"""
