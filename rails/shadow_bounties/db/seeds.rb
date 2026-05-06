seed_image_dir = Rails.root.join("db/seed_assets/bounties")

hunter_attributes = [
  { alias: "Rook Vale", rank: "S", region: "North Reach" },
  { alias: "Nyra Flint", rank: "A", region: "Ash Coast" },
  { alias: "Kade Voss", rank: "B", region: "Iron Divide" },
  { alias: "Talon Reed", rank: "S", region: "Sunfall Basin" },
  { alias: "Mira Thorn", rank: "A", region: "Emerald Wilds" },
  { alias: "Jax Hollow", rank: "C", region: "Dust Frontier" },
  { alias: "Sera Quill", rank: "B", region: "Moon Harbor" },
  { alias: "Bram Forge", rank: "A", region: "Obsidian Ridge" },
  { alias: "Iris Wren", rank: "B", region: "Storm March" },
  { alias: "Orin Pike", rank: "S", region: "Frost Line" }
]

bounty_attributes = [
  { target_name: "Crimson Wolf", threat_level: 4, reward_amount: 18_000, status: "open", last_seen: "Red Pine Forest", image_name: "crimson-wolf.jpg" },
  { target_name: "Iron Viper", threat_level: 5, reward_amount: 26_000, status: "captured", last_seen: "Black Quarry", image_name: "iron-viper.jpg" },
  { target_name: "Frost Tiger", threat_level: 8, reward_amount: 72_000, status: "open", last_seen: "Glacier Pass", image_name: "frost-tiger.jpg" },
  { target_name: "Night Raven", threat_level: 3, reward_amount: 12_500, status: "dead", last_seen: "Old Bell Tower", image_name: "night-raven.jpg" },
  { target_name: "Sand Jackal", threat_level: 6, reward_amount: 34_000, status: "open", last_seen: "Shifting Dunes", image_name: "sand-jackal.jpg" },
  { target_name: "Stone Rhino", threat_level: 9, reward_amount: 90_000, status: "captured", last_seen: "Broken Plateau", image_name: "stone-rhino.jpg" },
  { target_name: "Ghost Panther", threat_level: 7, reward_amount: 61_000, status: "open", last_seen: "Mistwood Ravine", image_name: "ghost-panther.jpg" },
  { target_name: "Red Falcon", threat_level: 2, reward_amount: 9_500, status: "dead", last_seen: "Cliffside Watch", image_name: "red-falcon.jpg" },
  { target_name: "Mire Crocodile", threat_level: 7, reward_amount: 58_000, status: "open", last_seen: "Fenwater Delta", image_name: "mire-crocodile.jpg" },
  { target_name: "Ash Gorilla", threat_level: 8, reward_amount: 75_000, status: "captured", last_seen: "Char Basin", image_name: "ash-gorilla.jpg" },
  { target_name: "Thunder Bear", threat_level: 9, reward_amount: 98_000, status: "open", last_seen: "Highstorm Ridge", image_name: "thunder-bear.jpg" },
  { target_name: "Coral Shark", threat_level: 5, reward_amount: 29_000, status: "dead", last_seen: "Siren Reef", image_name: "coral-shark.jpg" },
  { target_name: "Dune Scorpion", threat_level: 6, reward_amount: 31_500, status: "open", last_seen: "Salt Wastes", image_name: "dune-scorpion.jpg" },
  { target_name: "Ivory Owl", threat_level: 2, reward_amount: 8_000, status: "captured", last_seen: "Moon Grove", image_name: "ivory-owl.jpg" },
  { target_name: "Black Stallion", threat_level: 4, reward_amount: 17_000, status: "open", last_seen: "King's Run", image_name: "black-stallion.jpg" },
  { target_name: "Silver Fox", threat_level: 3, reward_amount: 11_000, status: "dead", last_seen: "Silverpine", image_name: "silver-fox.jpg" },
  { target_name: "Ember Lynx", threat_level: 5, reward_amount: 24_500, status: "open", last_seen: "Cinder Woods", image_name: "ember-lynx.jpg" },
  { target_name: "Marsh Boar", threat_level: 4, reward_amount: 16_500, status: "captured", last_seen: "Bog Run", image_name: "marsh-boar.jpg" },
  { target_name: "Storm Eagle", threat_level: 6, reward_amount: 37_000, status: "open", last_seen: "Skybreak Peak", image_name: "storm-eagle.jpg" },
  { target_name: "Venom Spider", threat_level: 5, reward_amount: 22_000, status: "dead", last_seen: "Webbed Hollow", image_name: "venom-spider.jpg" }
]

mission_attributes = [
  { hunter_alias: "Rook Vale", bounty_target: "Crimson Wolf", completed: false, notes: "Pack movement mapped near the northern ridge. Proceed with caution." },
  { hunter_alias: "Nyra Flint", bounty_target: "Iron Viper", completed: true, notes: "Target trapped in quarry tunnels and delivered alive." },
  { hunter_alias: "Kade Voss", bounty_target: "Frost Tiger", completed: false, notes: "Fresh tracks near the glacier camp. Needs backup." },
  { hunter_alias: "Talon Reed", bounty_target: "Night Raven", completed: true, notes: "Eliminated at the bell tower after a rooftop pursuit." },
  { hunter_alias: "Mira Thorn", bounty_target: "Sand Jackal", completed: false, notes: "Target uses decoys in the dunes. Water stores running low." },
  { hunter_alias: "Jax Hollow", bounty_target: "Stone Rhino", completed: true, notes: "Sedation darts worked. Extraction required heavy transport." },
  { hunter_alias: "Sera Quill", bounty_target: "Ghost Panther", completed: false, notes: "Sightings are inconsistent. Tracking team lost the trail in fog." },
  { hunter_alias: "Bram Forge", bounty_target: "Red Falcon", completed: true, notes: "Target neutralized after intercepting a cliffside dive." },
  { hunter_alias: "Iris Wren", bounty_target: "Mire Crocodile", completed: false, notes: "Swamp channels flooded. Mission extended by three days." },
  { hunter_alias: "Orin Pike", bounty_target: "Ash Gorilla", completed: true, notes: "Captured after luring the target into the canyon gate." },
  { hunter_alias: "Rook Vale", bounty_target: "Thunder Bear", completed: false, notes: "Storm activity is masking movement and limiting visibility." },
  { hunter_alias: "Nyra Flint", bounty_target: "Coral Shark", completed: true, notes: "Confirmed kill offshore. Reward cleared for release." },
  { hunter_alias: "Mira Thorn", bounty_target: "Dune Scorpion", completed: false, notes: "Nest identified beneath the salt flats. Awaiting fire crew." },
  { hunter_alias: "Orin Pike", bounty_target: "Storm Eagle", completed: false, notes: "Target circles above peak camps at dawn. Ballista support requested." }
]

Mission.delete_all
Bounty.delete_all
Hunter.delete_all

hunters_by_alias = hunter_attributes.to_h do |attributes|
  [attributes[:alias], Hunter.create!(attributes)]
end

bounties_by_target = bounty_attributes.to_h do |attributes|
  bounty = Bounty.new(attributes.except(:image_name))

  image_path = seed_image_dir.join(attributes[:image_name])
  bounty.poster_image = image_path.open if image_path.exist?

  bounty.save!
  [attributes[:target_name], bounty]
end

mission_attributes.each do |attributes|
  Mission.create!(
    hunter: hunters_by_alias.fetch(attributes[:hunter_alias]),
    bounty: bounties_by_target.fetch(attributes[:bounty_target]),
    completed: attributes[:completed],
    notes: attributes[:notes]
  )
end

puts "Seeded #{Hunter.count} hunters, #{Bounty.count} bounties, and #{Mission.count} missions."
