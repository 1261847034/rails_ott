class Wxmp::BaseController < ApplicationController

  def store_request_uuid
    RequestStore.store[:request_uuid] = request.uuid
  end

  def micro_messenger_browser?
    request.user_agent.to_s.include?('MicroMessenger')
  end

end