class Wxmp::BaseController < ApplicationController

  def store_request_uuid
    RequestStore.store[:request_uuid] = request.uuid
  end

end