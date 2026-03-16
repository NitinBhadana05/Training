# Base list used for testing
	nums = [3, 1, 4, 1, 5]

	print("Original list:", nums)

# -------------------------------------------------
# 1 append()
### Adds an element to the end of the list
	nums.append(9)
	print("append:", nums)
### Output: [3, 1, 4, 1, 5, 9]


# -------------------------------------------------
# 2 clear()
### Removes all elements from the list
	temp = nums.copy()
	temp.clear()
	print("clear:", temp)
### Output: []


# -------------------------------------------------
# 3 copy()
# Creates a shallow copy of the list
	copy_list = nums.copy()
	print("copy:", copy_list)
### Output: [3, 1, 4, 1, 5, 9]


# -------------------------------------------------
# 4 count()
### Counts how many times a value appears
	print("count:", nums.count(1))
### Output: 2


# -------------------------------------------------
# 5 extend()
### Adds elements from another iterable
	nums.extend([7, 8])
	print("extend:", nums)
### Output: [3, 1, 4, 1, 5, 9, 7, 8]


# -------------------------------------------------
# 6 index()
### Returns the index of the first occurrence of a value
	print("index:", nums.index(4))
### Output: 2


# -------------------------------------------------
# 7 insert()
### Inserts an element at a specific position
	nums.insert(2, 10)
	print("insert:", nums)
### Output: [3, 1, 10, 4, 1, 5, 9, 7, 8]


# -------------------------------------------------
# 8 pop()
### Removes and returns element at given index (default last)
	popped = nums.pop()
	print("pop:", nums)
### Output: [3, 1, 10, 4, 1, 5, 9, 7]


# -------------------------------------------------
# 9 remove()
### Removes the first occurrence of a value
	nums.remove(1)
	print("remove:", nums)
### Output: [3, 10, 4, 1, 5, 9, 7]


# -------------------------------------------------
# 10 reverse()
### Reverses the order of elements
	nums.reverse()
	print("reverse:", nums)
### Output: [7, 9, 5, 1, 4, 10, 3]


# -------------------------------------------------
# 11 sort()
### Sorts the list in ascending order
	nums.sort()
	print("sort:", nums)
### Output: [1, 3, 4, 5, 7, 9, 10]
