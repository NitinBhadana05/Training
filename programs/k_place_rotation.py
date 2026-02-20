def rotate_right(numbers: list[int], k: int) -> None:
    if len(numbers) == 0:
        raise ValueError("Invalid list")
    
    k %= len(numbers)
    result = [0] * len(numbers)
    for index in range(len(numbers)):
        
        new_index = (index + k ) %len(numbers)
        
        result[new_index] = numbers[index]
        
    print(result)
    
arr = [1,2,3,4,5]
rotate_right(arr,1)
        
        
"""
Output: [5,1,2,3,4]
"""
