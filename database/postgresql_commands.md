# Start PostgreSQL Service

### + Command Name 	:- Start PostgreSQL

	Description :-	Starts the PostgreSQL database server.

	Syntax :-     	sudo systemctl start postgresql

	Example :-    	sudo systemctl start postgresql



# Login to PostgreSQL

### + Command Name 	:- Login to PostgreSQL

	Description :-	Switch to postgres user and open psql terminal.

	Syntax :-     	sudo -i -u postgres
              		psql

	Example :-	sudo -i -u postgres
		psql


# Create Database

### + Command Name 	:- CREATE DATABASE

	Description :-	Creates a new database.

	Syntax :-		CREATE DATABASE database_name;

	Example :-		CREATE DATABASE school_project;



# Connect to Database

### + Command Name 	:- \c

	Description :-	Connects to a specific database.
	
	Syntax :-		\c database_name

	Example :-		\c school_project



# Create Table

### + Command Name 	:- CREATE TABLE

	Description :-	Creates a new table with specified columns.

	Syntax :-		CREATE TABLE table_name (
					column_name data_type constraints
					);

	Example :-	CREATE TABLE students (
				id SERIAL PRIMARY KEY,
				name TEXT NOT NULL,
				age INT
				);
		
		
		
# Insert Data

### + Command Name 	:- INSERT INTO

	Description :-	Adds new records into a table.

	Syntax :-	INSERT INTO table_name (column1, column2)
				VALUES (value1, value2);

	Example :-	INSERT INTO students (name, age)
				VALUES ('Alice', 20);
		
		
		
# View Data

### + Command Name 	:- SELECT

	Description :-	Retrieves data from a table.

	Syntax :-		SELECT * FROM table_name;

	Example :-		SELECT * FROM students;



# Create Second Table (Courses)

### + Command Name 	:- CREATE TABLE

	Description :-	Creates another table for storing course details.

	Syntax :-	CREATE TABLE courses (
				id SERIAL PRIMARY KEY,
				course_name TEXT NOT NULL
				);

	Example :-	CREATE TABLE courses (
				id SERIAL PRIMARY KEY,
				course_name TEXT NOT NULL
				);
		
		
		
# Create Relationship Table

### + Command Name 	:- CREATE TABLE (Foreign Key)

	Description :-	Creates a table with foreign key references to connect two tables.

	Syntax :-	CREATE TABLE table_name (
				column_name INT REFERENCES parent_table(column)
				);

	Example :-	CREATE TABLE enrollments (
				student_id INT REFERENCES students(id),
				course_id INT REFERENCES courses(id)
				);
		
		
		
# Insert Enrollment Data

### + Command Name 	:- INSERT INTO

	Description :-	Inserts relationship data between students and courses.

	Syntax :-		INSERT INTO enrollments (student_id, course_id)
					VALUES (value1, value2);

	Example :-		INSERT INTO enrollments (student_id, course_id)
					VALUES (1, 1);
		
# show list of Data base

### + Command Name  \l or \list

	Description :- give list of all database present in your device

	Syntax :- \l

	Example:- \l or \\list

# to modify thetabel
### + Command Name: ALTER TABLE

	Description: 	Modifies an existing table (add/drop constraints, modify columns, set defaults).

	Syntax:			ALTER TABLE table_name action;
	Example:		Add CHECK constraint:

			### ALTER TABLE users
				ADD CONSTRAINT users_salary_check
				CHECK (salary >= 0);

			### Drop constraint:

				ALTER TABLE users
				DROP CONSTRAINT users_salary_check;

			### Set default:

				ALTER TABLE attendance
				ALTER COLUMN status SET DEFAULT 'present';

			### Drop NOT NULL:

				ALTER TABLE attendance
				ALTER COLUMN check_in DROP NOT NULL;
		
# Constraints

## UNIQUE Constraint

	Description: 	Prevents duplicate values in a column.

	Syntax:			column_name data_type UNIQUE

	Example:		email VARCHAR(150) UNIQUE
		

## NOT NULL Constraint

	Description: 	Prevents NULL values.

	Syntax:			column_name data_type NOT NULL

	Example:		name VARCHAR(100) NOT NULL

## CHECK Constraint

	Description: 	Enforces a condition on column values.

	Syntax:	CHECK (condition)

	Example:	CHECK (budget >= 0)

# d (psql meta-command)

### + Command Name: \d

	Description: 	Shows table structure in psql.

	Syntax:	\d table_name

	Example:	\d departments
	
# Command Name: 	DROP TABLE

	Description:	Deletes a table permanently from the database.

	Syntax:	DROP TABLE table_name;

	Example:	DROP TABLE attendance;

	
	
# Command name:	PRIMARY KEY

	Description:	Ensures each row is uniquely identifiable. Automatically creates an index.

	Syntax:	column_name SERIAL PRIMARY KEY

	Example:	id SERIAL PRIMARY KEY
		
# command name: 	FOREIGN KEY

	Description:	Maintains relationship between two tables by enforcing referential integrity.

	Syntax:	FOREIGN KEY (column_name) REFERENCES parent_table(parent_column)

	Example:	FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE

# command name: 	DEFAULT

	Description:	Assigns a default value when no value is provided during insertion.

	Syntax:	column_name data_type DEFAULT value
	
	Example:	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	
# NULL Checking (Condition Operator)

	Description:	Used to test NULL values properly.

	Syntax:	column IS NULL column IS NOT NULL

	Example:	WHERE email IS NULL;
	
# Command name: 	SHOW

	Description:	Displays current configuration parameters.

	Syntax:	SHOW parameter_name;

	Example:	SHOW timezone;
	
#  Command name : 	SET

	Description:	Changes session-level configuration settings.

	Syntax:	SET parameter_name = value;

	Example:	SET timezone = 'UTC';

# Command name: 	CREATE INDEX

	Description:	Creates an index to improve query performance on specific columns.

	Syntax:	CREATE INDEX index_name ON table_name (column1, column2, ...);

	Example:	CREATE INDEX users_salary_idx ON users(salary);
			CREATE INDEX users_role_salary_idx ON users(role, salary);
# Command name:	EXPLAIN

	Description:	Shows the query execution plan (how PostgreSQL will execute a query).

	Syntax:	EXPLAIN query;

	Example:	EXPLAIN SELECT * FROM users WHERE salary = 200;
	

# Command name : 	EXPLAIN ANALYZE

	Description:	Executes the query and shows actual execution time and real performance statistics.

	Syntax:	EXPLAIN ANALYZE query;

	Example:	EXPLAIN ANALYZE SELECT * FROM users WHERE username = 'user40000';
	

# Command name: VACUUM

	Description:	Cleans dead rows and updates the visibility map, enabling better index-only scans.

	Syntax:	VACUUM table_name;

	Example:	VACUUM users;

# Command name :	generate_series()

	Description:	Generates a sequence of numbers (used for bulk test data insertion).

	Syntax:	SELECT generate_series(start, end);

	Example:	INSERT INTO users (username, password, role, salary) SELECT 'user' || g, 'pass', 'employee',  (g % 500)  FROM generate_series(1, 50000) g;
	


# Composite Index (Multi-Column Index)

	Description:	Index built on multiple columns to optimize multi-condition queries.

	Syntax:	CREATE INDEX index_name ON table_name (column1, column2);

	Example:	CREATE INDEX users_role_salary_idx ON users(role, salary);
	
	
# Leftmost Prefix Rule (Concept)

	Description: 	Composite index can only efficiently support queries that filter starting from the first column in the index.

	Example:	Index:(role, salary)
	
			Efficient: WHERE role = 'employee'; WHERE role = 'employee' AND salary = 200;

			Not efficient: WHERE salary = 200;
		
		
# CREATE INDEX WITH INCLUDE

	Description:	Creates a covering index that stores extra columns for index-only scans without affecting search key.

	Syntax:	CREATE INDEX index_name ON table_name (search_columns) INCLUDE (extra_columns);

	Example: 	CREATE INDEX users_role_salary_cover_idx ON users(role, salary) INCLUDE (username);

# CREATE INDEX (Partial)

	Description:	Creates an index only on rows matching a condition.

	Syntax:	CREATE INDEX index_name ON table_name (column_name) WHERE condition;

	Example:	CREATE INDEX users_admin_idx ON users(username) WHERE role = 'admin';


		
# pg_stat_user_indexes

	Description:	Shows statistics about index usage.

	Syntax: 	SELECT * FROM pg_stat_user_indexes;

	Example:	SELECT relname, indexrelname, idx_scan FROM pg_stat_user_indexes WHERE relname = 'users';
		
# Command name:	ANALYZE

	Description:	Collects statistics for query planner.

	Syntax:	ANALYZE table_name;

	Example:	ANALYZE users;
	
# Command name :	pg_stats

	Description:	View showing column statistics.

	Syntax:	SELECT * FROM pg_stats WHERE tablename = 'table_name';

	Example:	SELECT attname, n_distinct, most_common_vals FROM pg_stats WHERE tablename = 'users';
		
		
# Command name: 	INNER JOIN 

	Description:	It returns only matching rows from both tables. If no match → row excluded.

	Syntax:	SELECT columns FROM table1 INNER JOIN table2 ON table1.column = table2.column;
	
	Example	SELECT u.username, a.status FROM users u INNER JOIN attendance a ON u.id = a.user_id;

# Command name: 	INSERT INTO ... SELECT

	Description:	Inserts rows based on query result.

	Syntax:	INSERT INTO table_name (columns) SELECT columns FROM other_table; 
	
	Example:	INSERT INTO attendance (user_id, check_in, check_out, status) SELECT id, NOW(), NOW() + INTERVAL '8 hours', 'present' FROM users;
	
# Command name:		ORDER BY

	Description:	Sorts result set in specified order.

	Syntax:	SELECT columns FROM table ORDER BY column [ASC | DESC];

	Example:	SELECT * FROM attendance ORDER BY user_id ASC;

# Command name: HAVING

	Description:	Filters groups after GROUP BY.

	Syntax:		GROUP BY column HAVING aggregate_condition;

	Example:	HAVING COUNT(*) > 5;
	
# Command name:		COUNT(*)

	Description:	Counts total number of rows (including NULL values).

	Syntax:		SELECT COUNT(*) FROM table_name;

	Example:	SELECT COUNT(*) FROM attendance;
	
# Command name:		COUNT(column_name)

	Description:	Counts non-NULL values in a specific column.

	Syntax:		SELECT COUNT(column_name) FROM table_name;

	Example:	SELECT COUNT(check_in) FROM attendance;

# Command name:		COUNT() With JOIN

	Description:	Counts rows after joining tables.

	Syntax:		SELECT COUNT(*) FROM table1 INNER JOIN table2 ON condition;

	Example:	SELECT COUNT(*) FROM users u INNER JOIN attendance a ON u.id = a.user_id;
	
# Command name:		COUNT() With GROUP BY (Important)

	Description:	Counts rows per group.

	Syntax:		SELECT column, COUNT(*) FROM table GROUP BY column;

	Example:	SELECT user_id, COUNT(*) FROM attendance GROUP BY user_id;

# Command Name: 	CASE

	Description:	Conditional expression in SQL used to apply if-else logic inside queries.

	Syntax:		CASE WHEN condition THEN value WHEN condition THEN value ELSE value END
	
	Examples:
		- Example 1 –Simple Classification:	SELECT username, CASE WHEN role = 'admin' THEN 'High Access' ELSE 'Normal Access' END AS access_level FROM users;
						
		- Example 2 –Conditional Count:		SELECT COUNT(CASE WHEN status = 'present' THEN 1 END) FROM attendance;

		- Example 3 –Conditional SUM Alternative: SELECT SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END ) FROM attendance;

# Command Name: 	GROUP BY

	Description: 	Groups rows that have the same values in specified columns into summary rows, usually used with aggregate functions like:
			COUNT()
			SUM()
			AVG()
			MAX()
			MIN()
			
	Syntax:
		- basic for:	SELECT column1, aggregate_function(column2) FROM table_name GROUP BY column1; 
		- With JOIN:	SELECT t1.column, COUNT(*) FROM table1 t1 INNER JOIN table2 t2 ON condition GROUP BY t1.column;
		- With HAVING: 	SELECT column1, COUNT(*) FROM table_name GROUP BY column1 HAVING COUNT(*) > 5;
		
	Examples: 
		- Example 1 – Count Attendance Per User: SELECT user_id, COUNT(*) FROM attendance GROUP BY user_id;
		- Example 2 – With JOIN:		 SELECT u.username, COUNT(*) FROM users u INNER JOIN attendance a ON u.id = a.user_id GROUP BY u.username;
		- Example 3 – Using HAVING:		 SELECT user_id, COUNT(*) FROM attendance GROUP BY user_id HAVING COUNT(*) >= 5;
		
# Command Name:		LEFT JOIN

	Description:	
			Returns:
			- All rows from the left table
			- Matching rows from the right table
			- If no match → right table columns become NULL
			- It preserves all records from the left side.

	Syntax:		SELECT columns FROM left_table LEFT JOIN right_table ON left_table.column = right_table.colum
	
	Example:	SELECT u.username, a.status FROM users u LEFT JOIN attendance a ON u.id = a.user_id;

# Command Name:		AS (Column Alias)

	Description:	Renames a column or expression in query output.

	Syntax:		SELECT column AS new_name FROM table; 
	
	Example:	SELECT username AS user_name FROM users;

# Command Name:		RIGHT JOIN

	Description:	
			Returns:

			- All rows from the right table

			- Matching rows from the left table

			- If no match → left table columns become NULL

			- It preserves all records from the right side.

	Syntax:	
			-Basic Form:		SELECT columns FROM left_table RIGHT JOIN right_table ON left_table.column = right_table.column;
			-With Alias:		SELECT l.column, r.column FROM table1 l RIGHT JOIN table2 r ON l.id = r.foreign_id;
			-With NULL Handling:	SELECT r.column, CASE  WHEN l.column IS NULL THEN 'No Match' ELSE l.column END FROM table1 l RIGHT JOIN table2 r ON l.id = r.foreign_id;

	Example:	SELECT u.username, a.status FROM users u RIGHT JOIN attendance a ON u.id = a.user_id;


# Command Name:		WHERE

	Description:	Filters rows based on specified condition(s). Executed after FROM/JOIN and before GROUP BY.

	Syntax: 		SELECT columns FROM table_name WHERE condition;
	
	Example:		SELECT username, role FROM users WHERE role = 'employee';

# Command Name: 	LIKE

	Description: 	Pattern matching operator used inside WHERE clause.

	Wildcards: 		% → any number of characters
					_ → single character

	Syntax: 		SELECT columns FROM table_name WHERE column LIKE pattern; 
	
	Example:		SELECT username FROM users WHERE username LIKE 'a%';


# Command Name		AS

	Description:	Renames a column or table (alias). Improves readability.
	
	Syntax:			SELECT column AS new_name FROM table_name AS alias_name;
	
	Example:		SELECT username AS user_name FROM users;
	
# Command Name: 	BETWEEN

	Description:	Filters values within a range (inclusive).

	Syntax:			SELECT columns FROM table_name WHERE column BETWEEN value1 AND value2;
	
	Example:		SELECT username, salary FROM users WHERE salary BETWEEN 1000 AND 5000;
	
# Command Name:		IN

	Description:	Filters rows where column matches any value in a list.

	Syntax:			SELECT columns FROM table_name WHERE column IN (value1, value2, value3);
	
	Example:		SELECT username FROM users WHERE role IN ('admin', 'manager');


