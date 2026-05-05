class CoverImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  process resize_to_limit: [1400, 1400]
  process convert: "jpg"

  version :thumb do
    process resize_to_fill: [480, 320]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end

  def content_type_allowlist
    [/image\//]
  end

  def filename
    return unless original_filename

    "#{base_filename}.jpg"
  end

  private

  def base_filename
    @base_filename ||= File.basename(original_filename, ".*").parameterize
  end
end
