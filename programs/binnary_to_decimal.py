def power( exponent: int) -> int:
    base: int = 2
    result: int = 1
    for _ in range(exponent):
        result *= base
    return result
def binary_to_decimal(num: int) -> int:
    
   temp: int = 0
   result: int = 0
   while num != 0:
        digit: int = num % 10
        if digit > 1 or digit < 0:
           raise ValueError("invalid binarry number")
        result += digit*power(temp)
        
        temp +=1
        num //= 10
   return result
print(binary_to_decimal(10000))
        
    
    
"""
Output: 16

"""
