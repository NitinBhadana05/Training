# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Student.delete_all
Mark.delete_all




students = []

first_name = ["John", "Jane", "Bob", "Alice", "Charlie", "David", "Emily", "Frank", "Grace", "Henry"]
last_name = ["Doe", "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez"]
course = ["Arts", "Commerce", "Science", "IT"]
active = [true, false]

10.times do |i|
  students << Student.create!(
    name: "#{first_name[i]} #{last_name[i]}",
    email: "#{first_name[i]}@example.com",
    age: rand(16..24),
    course: course.sample,
    enroll_on: Date.today - i.days,
    actie: active.sample
  )
end

marks = []

subject = ["English", "Maths", "Science", "Social Studies"]
exam_type = ["Mid", "Final"]

10.times do
  m = rand(0..100)

  grade =
    if m >= 80
      "A"
    elsif m >= 60
      "B"
    elsif m >= 40
      "C"
    else
      "D"
    end

  marks << Mark.create!(
    student: students.sample,
    subject: subject.sample,
    marks: m,
    exam_type: exam_type.sample,
    grade: grade
  )
end