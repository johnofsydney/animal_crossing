class ApplicationController < ActionController::Base
  def is_user
    # TODO: add devise for users
    @is_user || false
  end
end
