# Base strings used for testing
	s = "hello world"
	text = "   python programming   "
	numbers = "12345"
	mixed = "Hello123"
	lines = "hello\nworld"
	csv = "apple,banana,grape"
	name = "rahul"

	print("Original:", s)

# -------------------------------------------------
# 1 capitalize()
### Converts the first character of the string to uppercase
	print("capitalize:", s.capitalize())
### Output: Hello world


# -------------------------------------------------
# 2 casefold()
### Converts string to lowercase (more aggressive than lower)
	print("casefold:", s.casefold())
### Output: hello world


# -------------------------------------------------
# 3 center()
### Aligns the string in the center with padding
	print("center:", s.center(20, "-"))
### Output: ----hello world-----


# -------------------------------------------------
# 4 count()
### Counts how many times a substring appears
	print("count:", s.count("l"))
### Output: 3


# -------------------------------------------------
# 5 encode()
### Converts string into bytes format
	print("encode:", s.encode())
### Output: b'hello world'


# -------------------------------------------------
# 6 endswith()
### Checks if string ends with given substring
	print("endswith:", s.endswith("world"))
### Output: True


# -------------------------------------------------
# 7 expandtabs()
### Replaces tab characters with spaces
	tab_text = "hello\tworld"
	print("expandtabs:", tab_text.expandtabs(4))
### Output: hello   world


# -------------------------------------------------
# 8 find()
# Returns index of substring (returns -1 if not found)
	print("find:", s.find("world"))
# Output: 6


# -------------------------------------------------
# 9 format()
### Formats values inside a string
	print("format:", "Hello {}".format("Rahul"))
### Output: Hello Rahul


# -------------------------------------------------
# 10 format_map()
### Similar to format() but uses dictionary
	data = {"name": "Rahul"}
	print("format_map:", "Hello {name}".format_map(data))
### Output: Hello Rahul


# -------------------------------------------------
# 11 index()
### Returns index of substring (gives error if not found)
	print("index:", s.index("world"))
### Output: 6


# -------------------------------------------------
# 12 isalnum()
### Returns True if string contains only letters and numbers
	print("isalnum:", mixed.isalnum())
### Output: True


# -------------------------------------------------
# 13 isalpha()
### Returns True if string contains only alphabets
	print("isalpha:", "python".isalpha())
### Output: True


# -------------------------------------------------
# 14 isascii()
### Checks if all characters are ASCII characters
	print("isascii:", s.isascii())
### Output: True


# -------------------------------------------------
# 15 isdecimal()
# Returns True if all characters are decimal numbers
print("isdecimal:", numbers.isdecimal())
# Output: True


# -------------------------------------------------
# 16 isdigit()
### Returns True if all characters are digits
	print("isdigit:", numbers.isdigit())
### Output: True


# -------------------------------------------------
# 17 isidentifier()
### Checks if string is a valid Python identifier
	print("isidentifier:", "variable_name".isidentifier())
### Output: True


# -------------------------------------------------
# 18 islower()
### Returns True if all characters are lowercase
	print("islower:", s.islower())
### Output: True


# -------------------------------------------------
# 19 isnumeric()
### Returns True if all characters are numeric
	print("isnumeric:", numbers.isnumeric())
### Output: True


# -------------------------------------------------
# 20 isprintable()
### Returns True if characters are printable
	print("isprintable:", s.isprintable())
### Output: True


# -------------------------------------------------
# 21 isspace()
### Returns True if string contains only whitespace
	print("isspace:", " ".isspace())
### Output: True


# -------------------------------------------------
# 22 istitle()
### Returns True if string follows title case format
	print("istitle:", "Hello World".istitle())
### Output: True


# -------------------------------------------------
# 23 isupper()
### Returns True if all characters are uppercase
	print("isupper:", "HELLO".isupper())
### Output: True


# -------------------------------------------------
# 24 join()
### Joins elements of a list into a single string
	words = ["hello", "python"]
	print("join:", " ".join(words))
### Output: hello python


# -------------------------------------------------
# 25 ljust()
### Left aligns string with padding
	print("ljust:", s.ljust(20, "-"))
### Output: hello world---------


# -------------------------------------------------
# 26 lower()
### Converts all characters to lowercase
	print("lower:", "HELLO".lower())
### Output: hello


# -------------------------------------------------
# 27 lstrip()
### Removes whitespace from the left side
	print("lstrip:", text.lstrip())
### Output: python programming   


# -------------------------------------------------
# 28 maketrans()
### Creates translation table for translate()
	table = str.maketrans("h", "y")
### Output: (translation table created)


# -------------------------------------------------
# 29 partition()
### Splits string into 3 parts based on first occurrence
	print("partition:", s.partition(" "))
### Output: ('hello', ' ', 'world')


# -------------------------------------------------
# 30 removeprefix()
### Removes specified prefix if present
	print("removeprefix:", "unhappy".removeprefix("un"))
### Output: happy


# -------------------------------------------------
# 31 removesuffix()
### Removes specified suffix if present
	print("removesuffix:", "file.txt".removesuffix(".txt"))
### Output: file


# -------------------------------------------------
# 32 replace()
### Replaces substring with another substring
	print("replace:", s.replace("world", "python"))
### Output: hello python


# -------------------------------------------------
# 33 rfind()
### Finds substring from right side
	print("rfind:", s.rfind("o"))
### Output: 7


# -------------------------------------------------
# 34 rindex()
### Same as rfind but raises error if not found
	print("rindex:", s.rindex("o"))
### Output: 7


# -------------------------------------------------
# 35 rjust()
# Right aligns string with padding
print("rjust:", s.rjust(20, "-"))
# Output: ---------hello world


# -------------------------------------------------
# 36 rpartition()
### Splits string into 3 parts starting from right
	print("rpartition:", s.rpartition(" "))
### Output: ('hello', ' ', 'world')


# -------------------------------------------------
# 37 rsplit()
### Splits string from right side
	print("rsplit:", csv.rsplit(",", 1))
### Output: ['apple,banana', 'grape']


# -------------------------------------------------
# 38 rstrip()
### Removes whitespace from right side
	print("rstrip:", text.rstrip())
### Output:    python programming


# -------------------------------------------------
# 39 split()
### Splits string into list using delimiter
	print("split:", csv.split(","))
### Output: ['apple', 'banana', 'grape']


# -------------------------------------------------
# 40 splitlines()
### Splits string at line breaks
	print("splitlines:", lines.splitlines())
### Output: ['hello', 'world']


# -------------------------------------------------
# 41 startswith()
### Checks if string starts with substring
	print("startswith:", s.startswith("hello"))
### Output: True


# -------------------------------------------------
# 42 strip()
### Removes whitespace from both sides
	print("strip:", text.strip())
### Output: python programming


# -------------------------------------------------
# 43 swapcase()
### Swaps uppercase to lowercase and vice versa
	print("swapcase:", "Hello World".swapcase())
### Output: hELLO wORLD


# -------------------------------------------------
# 44 title()
### Converts first letter of each word to uppercase
	print("title:", name.title())
### Output: Rahul


# -------------------------------------------------
# 45 translate()
### Translates characters using translation table
	print("translate:", s.translate(table))
### Output: yello world


# -------------------------------------------------
# 46 upper()
### Converts all characters to uppercase
	print("upper:", s.upper())
### Output: HELLO WORLD


# -------------------------------------------------
# 47 zfill()
### Pads string with zeros on the left
	print("zfill:", "42".zfill(5))
### Output: 00042



