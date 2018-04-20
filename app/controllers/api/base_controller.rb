class Api::BaseController < ApplicationController

  respond_to :json

  private
  def formated_response(data, options = {})
    _data = HashWithIndifferentAccess.new()

    _data["data"] = data
    _data.reverse_merge! options

    _data.reverse_merge!(code: "-1")

    _data
  end

  def default_serializer_options
    { root: false }
  end

end
