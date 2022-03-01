class ApplicationController < ActionController::Base
  def user?
    # TODO: add devise for users
    @user ||= false
  end
end
