def gcd(a: int, b:int) -> int:
    
 
    if a < 0:
        a = -a
        
    if b < 0:
        b = -b
        
    while b != 0:
        
        remainder = a % b
        a = b
        b = remainder
    
    return a
    
def co_prime(a: int, b: int):
    return gcd(a, b) == 1
    
print(co_prime(100,8))    
    

"""
Output: False

"""
