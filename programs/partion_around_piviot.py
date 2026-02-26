def partition(numbers: list[int], pivot: int) -> None:
    
    if len(numbers) == 0:
        raise ValueError("empty list not allowed")
    
    left: int = 0
    right: int = 0
    
    while right < len(numbers):
        
        if numbers[right] < pivot:
            temp: int = numbers[left]
            numbers[left] = numbers[right]
            numbers[right] = temp
            left += 1
        
            
        
        right +=  1
        
    print(numbers)

partition([6,4,5,3,2,1],4)
        
"""

Output: [3, 2, 1, 6, 4, 5]

"""
