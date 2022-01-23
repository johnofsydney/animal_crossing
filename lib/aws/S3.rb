require 'constants'

class S3

  def initialize
    @client = client
  end

  def client
    @client ||= Aws::S3::Client.new(
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    )
  end

  # def put_object(bucket:, key:, body:)
  #   binding.pry
  #   client.put_object(bucket:, key:, body:)
  # end

end