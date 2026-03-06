# a. Find the names of aircraft such that all pilots certified to operate them earn more than $80,000.

### code:

	select a.aname from airline.aircraft a where not exists ( select * from airline.certified c join airline.employees e on c.eid = e.eid where c.aid = a.aid and e.salary <= 80000);

### output:

	   aname 
	------------
	 Boeing 737
	  (1 row)

# b. For each pilot who is certified for more than three aircraft, find the eid and the maximum cruisingrange of the aircraft for which she or he is certified.

### code: 

	select c.eid, max(a.cruisingrange) as max_range from certified c join aircraft a on c.aid = a.aid group by c.eid having count(c.aid) > 3;
	
### output:
	 eid | max_long_range 
	-----+----------------
	  14 |           9700
	   3 |           9700
	  20 |           8000
	   9 |           8000
	   1 |           9700
	  16 |           9400
	  12 |           8000
	(7 rows)
	
# c. Find the names of pilots whose salary is less than the price of the cheapest route from Los Angeles to Honolulu

### code:

	select e.ename from airline.employees e	where e.salary < ( select min(r.price) from airline.flights r where r."from" = 'los angeles' and r."to" = 'honolulu');

### output:

	 ename 
	-------
	(0 rows)

# d. For all aircraft with cruisingrange over 1000 miles, find the name of the aircraft and the average salary of all pilots certified for this aircraft.

### code:

	select a.aname, avg(e.salary) from airline.aircraft a join airline.certified c on a.aid = c.aid join airline.employees e on c.eid = e.eid where a.cruisingrange > 1000 group by a.aname;

### output:
		 aname         |        avg 
	-----------------------+--------------------
	 Airbus A380           | 74250.000000000000
	 Airbus A340           | 60400.000000000000
	 Boeing 747            | 78000.000000000000
	 Airbus A320           | 72400.000000000000
	 Gulfstream G650       | 64000.000000000000
	 Boeing 787 Dreamliner | 73333.333333333333
	 Airbus A330           | 71833.333333333333
	 Airbus A350           | 64000.000000000000
	 Boeing 737            | 88600.000000000000
	 Bombardier CRJ900     | 69500.000000000000
	 Boeing 767            | 66750.000000000000
	 Boeing 777            | 72800.000000000000
	 Embraer E190          | 57500.000000000000
	(13 rows)


# e. Find the names of pilots certified for some Boeing aircraft.

### code:

	select distinct e.ename from airline.employees e join airline.certified c on e.eid = c.eid join airline.aircraft a on a.aid = c.aid where a.aname like 'boeing%';

### output:
	      ename
	-----------------
	 Amit Sharma
	 Anjali Sharma
	 Deepak Jadhav
	 Kavita Pawar
	 Kiran Patil
	 Nitin Patil
	 Pooja Joshi
	 Priya Kulkarni
	 Rahul Deshmukh
	 Rohit Patil
	 Sanjay Shinde
	 Sneha Kulkarni
	 Sunita Deshmukh
	 Vikram Shinde
	(14 rows)


# f. Find the aids of all aircraft that can be used on routes from Los Angeles to Chicago.

### code:
	
	select a.aid from airline.aircraft a where a.cruisingrange >=( select max(distance) from airline.flights where "from"='los angeles' and "to"='chicago');
	
### output:

	 aid 
	-----
	   1
	   2
	   3
	   4
	   5
	   6
	   7
	   8
	   9
	  10
	  11
	  14
	(12 rows)



# g. Identify the routes that can be piloted by every pilot who makes more than $100,000

### code:
	
	select f."from", f."to" from airline.flights f where not exists (select e.eid from airline.employees e where e.salary > 100000 and not exists (select * from airline.certified c join airline.aircraft a on a.aid = c.aid where c.eid = e.eid and a.cruisingrange >= f.distance));
	
### output:

	    from     |     to 
	-------------+-------------
	 Los Angeles | Chicago
	 Los Angeles | Chicago
	 Los Angeles | Chicago
	 Los Angeles | Honolulu
	 Los Angeles | Honolulu
	 Chicago     | New York
	 Chicago     | New York
	 Chicago     | New York
	 Madison     | Chicago
	 Madison     | Chicago
	 Madison     | Chicago
	 Chicago     | Honolulu
	 Chicago     | Honolulu
	 New York    | Los Angeles
	 New York    | Los Angeles
	 New York    | Chicago
	 New York    | Chicago
	 Madison     | New York
	 Madison     | New York
	 Los Angeles | New York
	 Los Angeles | New York
	 Honolulu    | Los Angeles
	 Honolulu    | Los Angeles
	 Chicago     | Madison
	 Chicago     | Madison
	 New York    | Madison
	 New York    | Madison
	 Los Angeles | Seattle
	 Los Angeles | Seattle
	 Seattle     | Chicago
	 Seattle     | Chicago
	 Chicago     | Seattle
	 Chicago     | Seattle
	 Seattle     | Los Angeles
	 Seattle     | Los Angeles
	 Honolulu    | Chicago
	 Honolulu    | Chicago
	 New York    | Honolulu
	 New York    | Honolulu
	 Honolulu    | New York
	(40 rows)

# h. Print the enames of pilots who can operate planes with cruisingrange greater than 3000 miles but are not certified on any Boeing aircraft?

### code:

	select distinct e.ename from airline.employees e join airline.certified c on e.eid = c.eid join airline.aircraft a on a.aid = c.aid where a.cruisingrange > 3000 and e.eid not in (select c.eid from airline.certified c join airline.aircraft a on a.aid = c.aid where a.aname like 'Boeing%' );

### output:
	     ename
	---------------
	 Ajay Kulkarni
	 Aniket Pawar
	 Meena Patil
	 Neha Patil
	 Ramesh Pawar
	 Sagar Jadhav
	(6 rows)

# i. A customer wants to travel from Madison to New York with no more than two changes of flight. List the choice of departure times from Madison if the customer wants to arrive in New York by 6 p.m.

### code:
	
	select f1.departs from airline.flights f1 where f1."from"='Madison' and f1."to"='New York' and f1.arrives <= '18:00' 
	union
	select f1.departs from airline.flights f1, airline.flights f2 where f1."from"='Madison' and f1."to"=f2."from" and f2."to"='New York' and f2.arrives <= '18:00'
	union
	select f1.departs from airline.flights f1, airline.flights f2, airline.flights f3 where f1."from"='Madison' and f1."to"=f2."from" and f2."to"=f3."from" and f3."to"='New York' and f3.arrives <= '18:00';

### output:
	 departs
	----------
	 06:30:00
	 07:00:00
	 11:30:00
	 15:00:00
	 17:30:00
	(5 rows)

# j. Compute the difference between the average salary of a pilot and the average salary of all employees (including pilots).

### code:
	
	select (select avg(e.salary) from airline.employees e where e.eid in (select c.eid from airline.certified c)) - (select avg(e2.salary) from airline.employees e2) as salary_difference;	
	
### output:
	salary_difference 
	-------------------
	 3400.000000000000
	(1 row)

# k. Print the name and salary of every nonpilot whose salary is more than the average salary for pilots.

### code:
	
	select e.ename,e.salary from airline.employees e where e.eid not in (select eid from airline.certified) and e.salary > (select avg(salary) from airline.employees where eid in (select eid from airline.certified));
	
### output:

	      ename      | salary 
	-----------------+--------
	 Mahesh Kulkarni |  82000
	 Ganesh Kulkarni |  84000
	 Abhishek Sharma |  78000
	 Yogesh Patil    |  74000
	 Tushar Patil    |  75000
	 Rohit Jadhav    |  72000
	 Sachin Patil    |  79000
	 Tejas Jadhav    |  73000
	(8 rows)

# l. Print the names of employees who are certified only on aircrafts with cruising range longer than 1000 miles.

### code:

	select distinct e.ename from airline.employees e join airline.certified c on e.eid=c.eid where not exists (select 1 from airline.certified c2 join airline.aircraft a on a.aid=c2.aid where c2.eid=e.eid and a.cruisingrange<=1000);
	
### output:

	     ename 
	----------------
	 Nitin Patil
	 Anjali Sharma
	 Ajay Kulkarni
	 Ramesh Pawar
	 Sanjay Shinde
	 Neha Patil
	 Kiran Patil
	 Rahul Deshmukh
	 Priya Kulkarni
	 Rohit Patil
	 Amit Sharma
	 Kavita Pawar
	 Sneha Kulkarni
	(13 rows)


# m. Print the names of employees who are certified only on aircrafts with cruising range longer than 1000 miles, but on at least two such aircrafts.

### code:

	select e.ename from airline.employees e join airline.certified c on e.eid=c.eid join airline.aircraft a on a.aid=c.aid group by e.eid,e.ename having count(c.aid)>=2 and not exists (select 1 from airline.certified c2 join airline.aircraft a2 on a2.aid=c2.aid where c2.eid=e.eid and a2.cruisingrange<=1000);

### output:

	     ename
	----------------
	 Amit Sharma
	 Rohit Patil
	 Sneha Kulkarni
	 Rahul Deshmukh
	 Priya Kulkarni
	 Anjali Sharma
	 Ramesh Pawar
	 Ajay Kulkarni
	 Sanjay Shinde
	 Kavita Pawar
	 Nitin Patil
	(11 rows)

# n. Print the names of employees who are certified only on aircrafts with cruising range longer than 1000 miles and who are certified on some Boeing aircraft.

### code:

	select distinct e.ename from airline.employees e join airline.certified c on e.eid=c.eid join airline.aircraft a on a.aid=c.aid where a.aname like 'Boeing%' and not exists (select 1 from airline.certified c2 join airline.aircraft a2 on a2.aid=c2.aid where c2.eid=e.eid and a2.cruisingrange<=1000);

### output:

	     ename 
	----------------
	 Amit Sharma
	 Anjali Sharma
	 Kavita Pawar
	 Kiran Patil
	 Nitin Patil
	 Priya Kulkarni
	 Rahul Deshmukh
	 Rohit Patil
	 Sanjay Shinde
	 Sneha Kulkarni
	(10 rows)


