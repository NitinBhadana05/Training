if Rails.env.development?
  Issue.destroy_all
  Book.destroy_all
  User.destroy_all

  User.find_or_create_by!(email: "admin@library.test") do |user|
    user.name = "Library Admin"
    user.password = "password"
    user.password_confirmation = "password"
    user.admin = true
  end

  users = 10.times.map do |index|
    User.find_or_create_by!(email: "member#{index + 1}@library.test") do |user|
      user.name = "Library Member #{index + 1}"
      user.password = "password"
      user.password_confirmation = "password"
      user.admin = false
    end
  end

  authors = [
    "Asha Mehta", "Rahul Verma", "Maya Rao", "Dev Patel", "Neha Kapoor",
    "Ishaan Bose", "Leela Nair", "Kabir Singh", "Tara Shah", "Vikram Joshi"
  ]

  genres = [
    "Rails", "Ruby", "Database", "Design", "Security",
    "Testing", "Architecture", "JavaScript", "Product", "Leadership"
  ]

  100.times do |index|
    number = index + 1
    Book.find_or_create_by!(isbn: "978000000#{number.to_s.rjust(4, "0")}") do |book|
      book.title = "#{genres[index % genres.length]} Handbook #{number}"
      book.author = authors[index % authors.length]
      book.available = true
    end
  end

  Book.order(:id).limit(8).each_with_index do |book, index|
    next unless book.available?

    Issue.create!(
      user: users[index % users.length],
      book: book,
      issue_date: Date.current - index.days
    )
  end
end
