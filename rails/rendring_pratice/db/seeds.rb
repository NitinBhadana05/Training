10.times do |i|
  ParkingSlot.create!(
    slot_number: "A#{i + 1}",
    status: "free"
  )
end