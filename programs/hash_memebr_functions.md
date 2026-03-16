# Base dictionary used for testing
	student = {
    	"name": "Rahul",
    	"age": 20,
    	"course": "CS"
}

	print("Original dictionary:", student)

# -------------------------------------------------
# 1 clear()
### Removes all elements from the dictionary
	temp = student.copy()
	temp.clear()
	print("clear:", temp)
### Output: {}


# -------------------------------------------------
# 2 copy()
### Creates a shallow copy of the dictionary
	copy_dict = student.copy()
	print("copy:", copy_dict)
### Output: {'name': 'Rahul', 'age': 20, 'course': 'CS'}


# -------------------------------------------------
# 3 fromkeys()
### Creates a new dictionary with specified keys
	keys = ["a", "b", "c"]
	new_dict = dict.fromkeys(keys, 0)
	print("fromkeys:", new_dict)
### Output: {'a': 0, 'b': 0, 'c': 0}


# -------------------------------------------------
# 4 get()
### Returns value of a key safely (no error if key not found)
	print("get:", student.get("name"))
# Output: Rahul


# -------------------------------------------------
# 5 items()
### Returns all key-value pairs
	print("items:", student.items())
### Output: dict_items([('name', 'Rahul'), ('age', 20), ('course', 'CS')])


# -------------------------------------------------
# 6 keys()
### Returns all keys from dictionary
	print("keys:", student.keys())
### Output: dict_keys(['name', 'age', 'course'])


# -------------------------------------------------
# 7 pop()
### Removes element with specified key
	temp2 = student.copy()
	temp2.pop("age")
	print("pop:", temp2)
### Output: {'name': 'Rahul', 'course': 'CS'}


# -------------------------------------------------
# 8 popitem()
### Removes the last inserted key-value pair
	temp3 = student.copy()
	temp3.popitem()
	print("popitem:", temp3)
### Output: {'name': 'Rahul', 'age': 20}


# -------------------------------------------------
# 9 setdefault()
### Returns value of key, creates key if not present
	temp4 = student.copy()
	temp4.setdefault("city", "Delhi")
	print("setdefault:", temp4)
### Output: {'name': 'Rahul', 'age': 20, 'course': 'CS', 'city': 'Delhi'}


# -------------------------------------------------
# 10 update()
### Updates dictionary with another dictionary
	temp5 = student.copy()
	temp5.update({"age": 21})
	print("update:", temp5)
### Output: {'name': 'Rahul', 'age': 21, 'course': 'CS'}


# -------------------------------------------------
# 11 values()
### Returns all values from dictionary
	print("values:", student.values())
### Output: dict_values(['Rahul', 20, 'CS'])
