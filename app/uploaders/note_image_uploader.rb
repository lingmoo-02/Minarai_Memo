class NoteImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick


  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'note_placeholder.png'
  end
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process resize_to_limit: [800, 800]
  process convert_to_webp: []

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [300, 200]
    process convert_to_webp: []
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png webp)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{secure_token}.webp" if original_filename.present?
  end

  private

  def convert_to_webp
    manipulate! do |image|
      image.format 'webp'
      image
    end
  end

  def secure_token
    @secure_token ||= SecureRandom.uuid
  end
end
