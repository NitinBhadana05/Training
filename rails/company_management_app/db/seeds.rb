# data for department table

dept = ["Sales", "Development", "Accounting", "HR", "Management", "Marketing",  "IT",]

dept.each do |name|
  Department.find_or_create_by!(name: name) do |d|
    d.status = true
  end
end

# data for employee table

employees_data = [
  { name: "Nitin", role: "Manager", dept: "HR", salary: 60000, doj: "2023-01-10" },
  { name: "Rahul", role: "Developer", dept: "IT", salary: 50000, doj: "2023-02-15" },
  { name: "Amit", role: "Accountant", dept: "Accounting", salary: 45000, doj: "2023-03-20" },
  { name: "Priya", role: "Developer", dept: "IT", salary: 52000, doj: "2023-04-05" },
  { name: "Sneha", role: "HR Exec", dept: "HR", salary: 40000, doj: "2023-05-12" },
  { name: "Karan", role: "Sales Exec", dept: "Sales", salary: 38000, doj: "2023-06-18" },
  { name: "Anjali", role: "Marketing Lead", dept: "Marketing", salary: 55000, doj: "2023-07-22" },
  { name: "Vikas", role: "Developer", dept: "IT", salary: 48000, doj: "2023-08-30" },
  { name: "Neha", role: "Finance Analyst", dept: "Accounting", salary: 47000, doj: "2023-09-14" },
  { name: "Arjun", role: "Manager", dept: "Management", salary: 65000, doj: "2023-10-01" }
]

employees_data.each do |emp|
  department = Department.find_by(name: emp[:dept])

  Employee.create!(
    name: emp[:name],
    role: emp[:role],
    department: department,
    salary: emp[:salary],
    date_of_join: emp[:doj]
  )
end

# data for project table

projects = []

10.times do |i|
  projects << Project.create!(
    name: "Project #{i + 1}",
    budget: rand(100000..500000),
    start_at: Date.today - rand(60..120),
    end_at: Date.today + rand(60..180)
  )
end





# data for assign table


employees = Employee.limit(9)

employees.each do |emp|
  projects.sample(2).each do |proj|
    Assign.find_or_create_by!(
      employee: emp,
      project: proj
    )
  end
end


# data for attendance table
start_date = Date.today - 90
end_date = Date.today

Employee.find_each do |emp|
  (start_date..end_date).each do |date|

    # Skip Sundays (optional)
    next if date.sunday?

    # 20% chance of absence
    if rand < 0.2
      Attendance.create!(
        employee: emp,
        attendance_date: date,
        check_in: nil,
        check_out: nil
      )
    else
      Attendance.create!(
        employee: emp,
        attendance_date: date,
        check_in: "09:00",
        check_out: "17:00"
      )
    end

  end
end

# data for book table

books = Book.create!([
  { title: "AI Basics", author: "Nitin", price: 500 },
  { title: "Cyber Security", author: "Rahul", price: 800 },
  { title: "Ruby on Rails", author: "Amit", price: 650 },
  { title: "Data Structures", author: "Suresh", price: 400 },
  { title: "Machine Learning", author: "Priya", price: 900 }
])

# data for order table
Order.create!([
  { user: "User1", book: books[0], issue_date: Date.today, return_date: Date.today + 3 },
  { user: "User2", book: books[1], issue_date: Date.today, return_date: Date.today + 5 },
  { user: "User3", book: books[2], issue_date: Date.today, return_date: Date.today + 2 },
  { user: "User4", book: books[3], issue_date: Date.today, return_date: Date.today + 4 },
  { user: "User5", book: books[4], issue_date: Date.today, return_date: Date.today + 6 },

  { user: "User6", book: books[0], issue_date: Date.today, return_date: Date.today + 7 },
  { user: "User7", book: books[1], issue_date: Date.today, return_date: Date.today + 3 },
  { user: "User8", book: books[2], issue_date: Date.today, return_date: Date.today + 5 },
  { user: "User9", book: books[3], issue_date: Date.today, return_date: Date.today + 2 },
  { user: "User10", book: books[4], issue_date: Date.today, return_date: Date.today + 4 }
])

# create authors
a1 = Author.create!(name: "Nitin")
a2 = Author.create!(name: "Rahul")
a3 = Author.create!(name: "Priya")

# use existing books
b1 = Book.first
b2 = Book.second

# create relationships
b1.authors << a1
b1.authors << a2

b2.authors << a2
b2.authors << a3
