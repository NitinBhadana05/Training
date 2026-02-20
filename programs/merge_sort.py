def merge_sorted(arr1: list[int], arr2: list[int]) -> list[int]:

    i: int = 0
    j: int = 0

    merged: list[int] = []

    while i < len(arr1) and j < len(arr2):

        if arr1[i] <= arr2[j]:
            merged.append(arr1[i])
            i += 1
        else:
            merged.append(arr2[j])
            j += 1

    # Add remaining elements
    while i < len(arr1):
        merged.append(arr1[i])
        i += 1

    while j < len(arr2):
        merged.append(arr2[j])
        j += 1

    return merged


arr1 = [1,2,3]
arr2 = [4,5,6]

print(merge_sorted(arr1,arr2))

"""
Output: [1,2,3,4,5,6]

"""
