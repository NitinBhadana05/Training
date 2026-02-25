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

# CREATE INDEX (Partial)

	Description:	Creates an index only on rows matching a condition.

	Syntax:	CREATE INDEX index_name ON table_name (column_name) WHERE condition;

	Example: 	CREATE INDEX users_admin_idx ON users(username) WHERE role = 'admin';
		
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
		
