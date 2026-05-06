class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  def extension_allowlist
    %w[jpg jpeg png webp]
  end
end