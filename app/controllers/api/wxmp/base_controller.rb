class Api::Wxmp::BaseController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  respond_to :json

end
