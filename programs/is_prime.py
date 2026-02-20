def is_prime(number: int) -> bool:
    if number <= 1:
        return False
    for i in range(2,int(number**0.5)+1):
        if number % i == 0:
            return False
    return True

def primes_in_range(start: int, end: int) -> int:
    
    count: int = 0
    for i in range(start,end):
        if is_prime(i):
            print(i)
            count += 1
    
    return count

print(primes_in_range(10,20))


"""
Output
2 3 5 7 11 13 17 19 
8
"""

