def power(base: int, exponent: int) -> int:
    
    if exponent == 0:
        return 1
    
    if exponent < 0:
        raise ValueError("Invalid exponent value")
    
    temp: int = 1
    result: int = 1
    while temp <= exponent:
        
        result *= base
        temp += 1
        
    return result
    
    
print(power(2,3))
    
    
"""
Output : 8

"""
