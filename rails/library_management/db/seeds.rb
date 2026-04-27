admin = User.find_or_initialize_by(email_address: "admin@library.com")
admin.update!(
  full_name: "Library Admin",
  password: "Password@123",
  password_confirmation: "Password@123",
  role: :admin
)

if Book.count.zero?
  [
    {
      title: "Practical Object-Oriented Design",
      author: "Sandi Metz",
      isbn: "9780134456478",
      category: "Software",
      description: "A practical guide to maintainable object-oriented application design.",
      total_copies: 5,
      available_copies: 5,
      daily_rent: 12,
      purchase_price: 75
    },
    {
      title: "Clean Code",
      author: "Robert C. Martin",
      isbn: "9780132350884",
      category: "Software",
      description: "Techniques and habits for writing readable and maintainable code.",
      total_copies: 4,
      available_copies: 4,
      daily_rent: 10,
      purchase_price: 65
    },
    {
      title: "The Pragmatic Programmer",
      author: "David Thomas and Andrew Hunt",
      isbn: "9780135957059",
      category: "Software",
      description: "A field guide to craftsmanship and pragmatic software development.",
      total_copies: 6,
      available_copies: 6,
      daily_rent: 11,
      purchase_price: 70
    }
  ].each { |attributes| Book.create!(attributes) }
end
