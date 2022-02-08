class S3
  # TODO: S3 refactors
  # - permissions for S3 bucket are too lax
  # - make a plural version: put_objects

  REGION = 'us-east-1'.freeze

  attr_reader :bucket

  def initialize(bucket)
    @bucket = bucket
  end

  def client
    @client ||= Aws::S3::Client.new(
      region: REGION,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key
    )
  end

  def put_object(key:, body:)
    client.put_object(bucket: bucket, key: key, body: body)

    # TODO: handle error in saving
    {
      success: true,
      bucket: bucket,
      key: key,
      address: "http://#{bucket}.s3.#{REGION}.amazonaws.com/#{key}"
    }
  end

  def delete_object(key:)
    # TODO: setup logger
    # logger.debug "Deleting #{key} from #{bucket}. INFO"
    # logger.info "Deleting #{key} from #{bucket}. DEBUG"

    client.delete_object(bucket: bucket, key: key)

    # TODO: handle error in deletion
    {
      success: true,
      bucket: bucket,
      key: key
    }
  end

  def access_key_id
    Rails.application.credentials.aws[:access_key_id]
  rescue NoMethodError => e
    e.inspect # fix for CI
  end

  def secret_access_key
    Rails.application.credentials.aws[:secret_access_key]
  rescue NoMethodError => e
    e.inspect # fix for CI
  end
end
