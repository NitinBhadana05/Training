def max_sum_subarray(numbers: list[int], k: int) -> int:

    if k <= 0 or k > len(numbers):
        raise ValueError("Invalid window size")

    # Step 1: Calculate sum of first window
    current_sum: int = 0
    for index in range(k):
        current_sum += numbers[index]

    max_sum: int = current_sum

    # Step 2: Slide the window
    for index in range(k, len(numbers)):

        # Remove element going out of window
        current_sum -= numbers[index - k]

        # Add new element coming into window
        current_sum += numbers[index]

        # Update max if needed
        if current_sum > max_sum:
            max_sum = current_sum

    return max_sum

    
print(max_sum_subarray([1,2,3,4,5],3))
        
    
"""
Output: 12
"""
