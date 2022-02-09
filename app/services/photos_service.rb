require 'aws/s3'

class PhotosService
  attr_reader :animal, :params, :photo_bucket

  def initialize(animal, params = {})
    @animal = animal
    @params = params
    @photo_bucket = S3.new(S3::PHOTO_BUCKET)
  end

  # adds several photo files to S3, and inserts records to DB
  def add_photos
    images = params['animal']['photos'].select(&:present?)
    return if images.blank?

    images.each do |image|
      add_image_to_animal(image)
    end

    @animal.save
  end

  # Deletes all an animals photos from S3 and destroys the DB records
  def delete_photos
    animal.photos.each do |photo|
      key = photo.address.split('/').last
      photo_bucket.delete_object(key: key)
    end

    animal.photos.destroy_all
  end

  # deletes a single photo from S3 and destroys the DB record
  def delete_photo
    animal_id = params[:animal_id].to_i
    photo_id = params[:photo_id].to_i

    @animal = Animal.find(animal_id)
    photo = Photo.find(photo_id)

    # delete object from bucket
    key = photo.address.split('/').last

    photo_bucket.delete_object(key: key)

    # destroy rails record
    animal.photos.destroy(photo)
  end

  private

  def animal_name
    animal.name || animal_params[:name] || ''
  end

  def add_image_to_animal(image)
    upload_results = photo_bucket.put_object(
      key: "photo-#{Time.zone.today}-#{animal_name}-#{SecureRandom.hex(2)}",
      body: image.tempfile
    )

    animal.photos << Photo.new(address: upload_results[:address])
  end
end
