def reverse_list(numbers: list[int], start: int, end: int) -> None:
    while start < end:
        temp: int = numbers[start]
        numbers[start] = numbers[end]
        numbers[end] = temp
        
        start += 1
        end -= 1

def rotate_right(numbers: list[int], k: int) -> None:
    if len(numbers) == 0:
        raise ValueError("Invalid list")
        
    k %= len(numbers)
    
    reverse_list(numbers, 0, len(numbers)-1)
    reverse_list(numbers, 0, k-1)
    reverse_list(numbers, k,len(numbers)-1)
    

arr = [1,2,3,4,5]
rotate_right(arr,2)
print(arr)       
        

"""
Output:

[4,5,1,2,3]

"""
