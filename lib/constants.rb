module Aws
  ACCESS_KEY = access_key_id = Rails.application.credentials.aws[:access_key_id]
  SECRET_ACCESS_KEY = secret_access_key = Rails.application.credentials.aws[:secret_access_key]
end