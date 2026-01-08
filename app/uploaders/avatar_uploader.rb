class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'default_avatar.webp'
  end

  # Process files as they are uploaded:
  process resize_to_fill: [400, 400]
  process convert_to_webp: []

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png webp)
  end

  # Override the filename of the uploaded files:
  def filename
    "#{secure_token}.webp" if original_filename.present?
  end

  private

  def convert_to_webp
    return if file.nil?

    cache_stored_file! if !cached?
    image = ::MiniMagick::Image.open(current_path)
    image.format('webp', quality: 80)
    self.file = CarrierWave::SanitizedFile.new(current_path)
  end

  def secure_token
    @secure_token ||= SecureRandom.uuid
  end
end
