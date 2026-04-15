# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clean DB (optional)
Borrow.delete_all
Copy.delete_all
BookAuthor.delete_all
Book.delete_all
Author.delete_all
Category.delete_all
Publisher.delete_all
User.delete_all

# ---------- USERS ----------
users = []
10.times do |i|
  users << User.create!(
    name: "User#{i}",
    email: "user#{i}@test.com",
    role: i == 0 ? "admin" : "member",
    phone: "99999#{1000 + i}",
    address: "Delhi #{i}",
    active: true
  )
end

# ---------- AUTHORS ----------
authors = []
10.times do |i|
  authors << Author.create!(
    name: "Author#{i}",
    bio: "Bio of author #{i}",
    dob: Date.new(1980+i, 1, 1)
  )
end

# ---------- PUBLISHERS ----------
publishers = []
5.times do |i|
  publishers << Publisher.create!(
    name: "Publisher#{i}",
    location: "City#{i}"
  )
end

# ---------- CATEGORIES ----------
categories = []
5.times do |i|
  categories << Category.create!(
    name: ["Tech", "Science", "History", "Fiction", "Business"][i],
    description: "Category #{i}"
  )
end

# ---------- BOOKS ----------
books = []
20.times do |i|
  books << Book.create!(
    title: "Book#{i}",
    isbn: "1234567890#{100 + i}",  # 13 digits
    published_on: Date.today - i.years,
    language: "English",
    pages: rand(100..500),
    category: categories.sample,
    publisher: publishers.sample
  )
end

# ---------- BOOK AUTHORS (JOIN TABLE) ----------
books.each do |book|
  book.authors << authors.sample(2)
end

# ---------- COPIES ----------
copies = []
books.each do |book|
  3.times do |i|
    copies << Copy.create!(
      book: book,
      barcode: "B#{book.id}C#{i}",
      status: "available",
      shelf_location: "S#{rand(1..10)}",
      price: rand(200..1000)
    )
  end
end

# ---------- BORROWS ----------
copies.sample(30).each do |copy|
  Borrow.create!(
    user: users.sample,
    copy: copy,
    issued_at: Time.now - rand(1..5).days,
    due_at: Time.now + rand(5..10).days,
    status: "issued",
    fine: 0
  )
end

puts "✅ Seed data created successfully!"