def reverse(arr: list[int]) -> list[int]:
    left: int = 0
    right: int = len(arr)-1
    
    while left < right:
        
        temp: int = arr[left]
        arr[left] = arr[right]
        arr[right] = temp
                
        left += 1
        right -= 1
    return arr
def print_divisors(number: int) -> None:
    
    if number <= 0:
        raise ValueError("invalid number")
    
    small_divisors: list[int] = []
    large_divisors: list[int] = []
    for i in range(1,int(number**0.5)+1):
        
        if number % i == 0:
            small_divisors.append(i)
            if i * i == number:
                continue
            large_divisors.append(number//i)
    print(small_divisors + reverse(large_divisors))
        
print_divisors(36)

"""
Output:

[1, 2, 3, 4, 6, 9, 12, 18, 36]
"""
