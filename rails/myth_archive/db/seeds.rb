require "fileutils"
require "open-uri"

regions = [
  "Arctic Frontier",
  "Desert Expanse",
  "Emerald Jungle",
  "Storm Coast",
  "Obsidian Ridge",
  "Sunken Delta",
  "Moonlit Valley",
  "Crimson Steppe",
  "Frost Hollow",
  "Golden Basin"
]

artifact_names = [
  "Echo Compass",
  "Sun Dial Shard",
  "Whispering Orb",
  "Ivory Relic",
  "Celestial Map",
  "Runic Lantern",
  "Stormglass",
  "Ashen Crown",
  "Tidal Charm",
  "Obsidian Sigil"
]

countries = [
  "India",
  "Peru",
  "Iceland",
  "Morocco",
  "Japan",
  "Egypt",
  "Brazil",
  "Kenya",
  "Norway",
  "Mexico"
]

image_sources = [
  {
    filename: "artifact_inscription.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_with_inscription_on_it.jpg"
  },
  {
    filename: "artifact_castle.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_found_in_the_castle.jpg"
  },
  {
    filename: "artifact_market_square_25.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square_25.jpg"
  },
  {
    filename: "artifact_market_square_main.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square.jpg"
  },
  {
    filename: "artifact_market_square_15.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square_15.jpg"
  },
  {
    filename: "artifact_vani_museum.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archeological_Artifact_at_Vani_Archeological_Museum.jpg"
  },
  {
    filename: "artifact_market_square_23.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square_23.jpg"
  },
  {
    filename: "artifact_market_square_13.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square_13.jpg"
  },
  {
    filename: "artifact_market_square_3.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/Archaeological_artifact_on_display_at_Market_Square_3.jpg"
  },
  {
    filename: "artifact_indian.jpg",
    url: "https://commons.wikimedia.org/wiki/Special:FilePath/PSM_V08_D083_Ancient_indian_artifact.jpg"
  }
]

image_dir = Rails.root.join("db", "seeds", "artifact_images")
FileUtils.mkdir_p(image_dir)

downloaded_images = image_sources.map do |image_source|
  path = image_dir.join(image_source[:filename])

  next path if path.exist? && path.size > 10_000

  begin
    URI.open(image_source[:url]) do |remote_file|
      path.binwrite(remote_file.read)
    end
  rescue StandardError => error
    warn "Skipping #{image_source[:filename]} download: #{error.message}"
  end

  path
end

downloaded_images.select! { |path| path.exist? && path.size > 10_000 }

Artifact.delete_all
Explorer.delete_all

explorers = 10.times.map do |index|
  Explorer.create!(
    codename: "Explorer #{index + 1}",
    reputation: (index % 10) + 1,
    region: regions[index]
  )
end

50.times do |index|
  explorer = explorers[index % explorers.size]

  Artifact.create!(
    explorer: explorer,
    name: "#{artifact_names[index % artifact_names.size]} #{index + 1}",
    description: "Recovered during expedition #{(index / 5) + 1} by #{explorer.codename}.",
    origin_country: countries[index % countries.size],
    danger_level: (index % 10) + 1,
    discovered_on: Date.current - index.days,
    image: downloaded_images.any? ? File.open(downloaded_images[index % downloaded_images.size]) : nil
  )
end

puts "Seeded #{Explorer.count} explorers and #{Artifact.count} artifacts."
