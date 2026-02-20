def reverse_number(number: int) -> int:

    if number == 0:
        return 0

    is_negative: bool = False

    if number < 0:
        is_negative = True
        number = -number

    reversed_number: int = 0

    while number > 0:
        last_digit: int = number % 10
        reversed_number = reversed_number * 10 + last_digit
        number = number // 10

    if is_negative:
        reversed_number = -reversed_number

    return reversed_number



def is_palindrome(number: int) -> bool:

    if number < 0:
        return False

    reversed_number: int = reverse_number(number)

    if reversed_number == number:
        return True

    return False
  
      
print(is_palindrome(int(input("enter number "))))


"""
Output

enter number 121
True


"""
