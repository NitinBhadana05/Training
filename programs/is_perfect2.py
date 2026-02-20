def is_perfect(number: int) -> bool:
    
    if number <= 1:
        return False
        
    total: int = 0
    
    for i in range(1,number):
        if number % i ==  0:
            total  += i
    return total == number

print(is_perfect(6))

"""
Output

True
"""
