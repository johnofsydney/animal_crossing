class S3
  REGION = 'us-east-1'.freeze
  S3_ACCESS_KEY_ID = access_key_id
  S3_SECRET_ACCESS_KEY = secret_access_key

  def initialize
    @client = client
  end

  def client
    @client ||= Aws::S3::Client.new(
      region: REGION,
      access_key_id: S3_ACCESS_KEY_ID,
      secret_access_key: S3_SECRET_ACCESS_KEY
    )
  end

  # rubocop:disable Metrics/MethodLength
  def self.put_object(bucket:, key:, body:)
    new.client.put_object(bucket: bucket, key: key, body: body)

    # TODO: handle error in saving
    {
      success: true,
      bucket: bucket,
      key: key,
      address: "http://#{bucket}.s3.#{REGION}.amazonaws.com/#{key}"
    }
  end

  def self.delete_object(bucket:, key:)
    # TODO: setup logger
    # logger.debug "Deleting #{key} from #{bucket}. INFO"
    # logger.info "Deleting #{key} from #{bucket}. DEBUG"

    new.client.delete_object(bucket: bucket, key: key)

    # TODO: handle error in deletion
    {
      success: true,
      bucket: bucket,
      key: key
    }
  end

  def access_key_id
    Rails.application.credentials.aws[:access_key_id]
  rescue => e # rubocop:disable Style/RescueStandardError
    e.inspect
    'rescued'
  end

  def secret_access_key
    Rails.application.credentials.aws[:secret_access_key]
  rescue => e # rubocop:disable Style/RescueStandardError
    e.inspect
    'rescued'
  end
  # rubocop:enable Metrics/MethodLength
end
