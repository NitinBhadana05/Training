def right_rotation(numbers: list[int]) -> None:
    if len(numbers) == 0:
        raise ValueError("Invalid list")
    
    last_value: int = numbers[-1]
    
    for index  in range(len(numbers)-1,0,-1):
        
        numbers[index] = numbers[index-1]
    numbers[0] = last_value

arr = [1,2,3,4,5]
right_rotation(arr)
print(arr)

"""
Output

[5,1,2,3,4]

"""
