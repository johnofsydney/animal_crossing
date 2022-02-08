require 'aws/s3'

class AddPhotosService
  PHOTO_BUCKET = 'doolittle-a1'.freeze

  attr_reader :animal, :params

  def initialize(animal, params)
    @animal = animal
    @params = params
  end

  def process
    images = params['animal']['photos'].select(&:present?)
    return if images.blank?

    s3 = S3.new

    images.each do |image|
      add_image_to_animal(image, s3)
    end

    @animal.save
  end

  private

  def animal_name
    @animal.name || animal_params[:name] || ''
  end

  def add_image_to_animal(image, s3_bucket)
    upload_results = s3_bucket.put_object(
      bucket: PHOTO_BUCKET,
      key: "photo-#{Time.zone.today}-#{animal_name}-#{SecureRandom.hex(2)}",
      body: image.tempfile
    )

    @animal.photos << Photo.new(address: upload_results[:address])
  end
end
