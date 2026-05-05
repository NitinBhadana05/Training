prefixes = [
  "Whispering", "Vanishing", "Midnight", "Burning", "Hidden",
  "Crying", "Shadow", "Howling", "Silver", "Crooked"
]

subjects = [
  "Bridge", "Bus Stop", "Lantern", "Hostel", "Well",
  "Signal", "Market", "Temple", "Alley", "Cinema"
]

locations = [
  "Delhi", "Mumbai", "Kolkata", "Chennai", "Bengaluru",
  "Hyderabad", "Pune", "Lucknow", "Jaipur", "Goa"
]

descriptions = [
  "Locals say the sound appears only after midnight and disappears before sunrise.",
  "Witnesses describe the same pattern every monsoon, but nobody agrees on the source.",
  "The story spreads through students, drivers, and shopkeepers with just enough detail to feel true.",
  "People avoid the area after dark because the rumor has survived for years without a clear explanation.",
  "Some claim it started as a prank, but the details became stranger each time it was retold."
]

50.times do |index|
  prefix = prefixes[index / subjects.length]
  subject = subjects[index % subjects.length]
  location = locations[index % locations.length]
  title = "#{prefix} #{subject}"
  description = "#{descriptions[index % descriptions.length]} Report ##{index + 1} references #{location}."

  Legend.find_or_create_by!(title: title) do |legend|
    legend.location = location
    legend.description = description
    legend.credibility_score = (index % 10) + 1
  end
end

puts "Seeded #{Legend.count} legends"
