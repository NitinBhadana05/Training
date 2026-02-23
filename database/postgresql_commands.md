# Start PostgreSQL Service

Command Name 	Start PostgreSQL

Description :-	Starts the PostgreSQL database server.

Syntax :-     	sudo systemctl start postgresql

Example :-    	sudo systemctl start postgresql



# Login to PostgreSQL

Command Name 	Login to PostgreSQL

Description :-	Switch to postgres user and open psql terminal.

Syntax :-     	sudo -i -u postgres
              	psql

Example :-	sudo -i -u postgres
		psql


# Create Database

Command Name 	CREATE DATABASE

Description :-	Creates a new database.

Syntax :-	CREATE DATABASE database_name;

Example :-	CREATE DATABASE school_project;



# Connect to Database

Command Name 	\c

Description :-	Connects to a specific database.

Syntax :-	\c database_name

Example :-	\c school_project



# Create Table

Command Name 	CREATE TABLE

Description :-	Creates a new table with specified columns.

Syntax :-	CREATE TABLE table_name (
		column_name data_type constraints
		);

Example :-	CREATE TABLE students (
		id SERIAL PRIMARY KEY,
		name TEXT NOT NULL,
		age INT
		);
		
		
		
# Insert Data

Command Name 	INSERT INTO

Description :-	Adds new records into a table.

Syntax :-	INSERT INTO table_name (column1, column2)
		VALUES (value1, value2);

Example :-	INSERT INTO students (name, age)
		VALUES ('Alice', 20);
		
		
		
# View Data

Command Name 	SELECT

Description :-	Retrieves data from a table.

Syntax :-	SELECT * FROM table_name;

Example :-	SELECT * FROM students;



# Create Second Table (Courses)

Command Name 	CREATE TABLE

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

Command Name 	CREATE TABLE (Foreign Key)

Description :-	Creates a table with foreign key references to connect two tables.

Syntax :-	CREATE TABLE table_name (
		column_name INT REFERENCES parent_table(column)
		);

Example :-	CREATE TABLE enrollments (
		student_id INT REFERENCES students(id),
		course_id INT REFERENCES courses(id)
		);
		
		
		
# Insert Enrollment Data

Command Name 	INSERT INTO

Description :-	Inserts relationship data between students and courses.

Syntax :-	INSERT INTO enrollments (student_id, course_id)
		VALUES (value1, value2);

Example :-	INSERT INTO enrollments (student_id, course_id)
		VALUES (1, 1);
		
		
		
		
		
		
		
		
		
		
		
