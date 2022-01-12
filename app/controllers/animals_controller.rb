class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[ show edit update destroy ]

  # GET /animals or /animals.json
  def index
    @animals = Animal.all
  end

  # GET /animals/1 or /animals/1.json
  def show
  end

  # GET /animals/new
  def new
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit
  end

  # POST /animals or /animals.json
  def create
    @animal = Animal.new(animal_params)

    respond_to do |format|
      if @animal.save
        format.html { redirect_to animal_url(@animal), notice: "Animal was successfully created." }
        format.json { render :show, status: :created, location: @animal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    # TODO: S3 refactors
    # - refactor S3 to library code
    # - constants file for keys etc
    # - bucket name for each stage
    # - permissions for S34 bucket are too lax
    # - filename (key) should have date / time information in it.
    s3 = Aws::S3::Client.new(
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    )

    bucket = 'doolittle-a1'

    # TODO: - safe params for nested photo attributes
    images = params['animal']['photos'].select(&:present?)

    images.each do |image|
      file = image.tempfile
      key = "photo-#{SecureRandom.hex(2)}"

      s3.put_object(
        bucket: bucket,
        key: key,
        body: file
      )

      photo = Photo.new(address: "http://#{bucket}.s3.us-east-1.amazonaws.com/#{key}")
      @animal.photos << photo
    end

    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to animal_url(@animal), notice: "Animal was successfully updated." }
        format.json { render :show, status: :ok, location: @animal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    # 1 delete photos from bucket
    # TODO - refactor to use code from single delete_photo method below
    s3 = Aws::S3::Client.new(
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    )

    bucket = 'doolittle-a1'

    @animal.photos.each do |photo|
      key = photo.address.split('/').last

      s3.delete_object(
        bucket: bucket,
        key: key
      )
    end

    @animal.destroy

    respond_to do |format|
      format.html { redirect_to animals_url, notice: "Animal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_photo
    animal_id = params[:animal_id].to_i
    photo_id = params[:photo_id].to_i

    @animal = Animal.find(params[:animal_id])
    photo = Photo.find(photo_id)

    # 1 delete object from bucket
    key = photo.address.split('/').last
    s3 = Aws::S3::Client.new(
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    )

    bucket = 'doolittle-a1'

    s3.delete_object(
      bucket: bucket,
      key: key
    )

    # 2 destroy rails record
    @animal.photos.destroy(photo)

    # redirect_to @animal
    redirect_to edit_animal_path(@animal)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_animal
    @animal = Animal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def animal_params
    params.require(:animal).permit(:name, :dob, :description, :size)
  end
end
