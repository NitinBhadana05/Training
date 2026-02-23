def gcd_basic(a: int, b: int) -> int:

    if a < 0 :
        a = -a
    
    if b < 0 :
        b = -b
        
    if a == 0:
        return b
    
    elif b == 0:
        return a
      
    smallest: int = a if a < b else b
   
    great_divisor: int = 1
   
    for i in range(1, smallest+1):
       if a % i == 0 and b % i == 0:
           great_divisor = i
    
    return great_divisor

print(gcd_basic(24,36))
    

"""
Output: 12
"""
