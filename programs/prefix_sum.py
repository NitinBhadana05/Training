def prefix_sum(numbers: list[int]) -> list[int]:
    if len(numbers) == 0:
        raise ValueError("invalid list")
    
    prefix_list: list[int] = []
    total: int = 0
    for index in range(len(numbers)):
        total += numbers[index]
        prefix_list.append(total)
    
    return prefix_list


print(prefix_sum([1,2,3,4,3,4,4]))
        

"""
Output :  [1, 3, 6, 10, 13, 17, 21]

"""
