def find_factor(number: int) -> list:
    if number < 1:
        return []
    
    result: list[int] = []
    for num in range(1,number):
        if  number%num == 0:
            result.append(num)
    return result

print(find_factor(6))

def is_perfect(number: int) -> bool:
    
    if number < 0 :
        return False
    total: int = 0
    factor: list[int] = find_factor(number)
    for i in factor:
        total += i
        
    return total == number
    
print(is_perfect(28))
        
        
"""
Output

True
"""
