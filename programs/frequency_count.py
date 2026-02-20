def frequency_count(numbers: list[int]) -> None:

    if len(numbers) == 0:
        raise ValueError("Invalid list")

    visited: list[bool] = [False] * len(numbers)

    for i in range(len(numbers)):

        if visited[i]:
            continue

        count: int = 1

        for j in range(i + 1, len(numbers)):
            if numbers[i] == numbers[j]:
                count += 1
                visited[j] = True

        print(numbers[i], "->", count, "times")

    
arr = [1,2,2,2,3,3,4,5]
frequency_count(arr)

"""
Output:

1 -> 1 times
2 -> 3 times
3 -> 2 times
4 -> 1 times
5 -> 1 times

"""
