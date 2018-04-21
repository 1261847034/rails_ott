module Wxmpish
  module Interface
    extend ActiveSupport::Concern

    def get_access_token
      get "cgi-bin/token?grant_type=client_credential&appid=#{wx_mp_user.app_id}&secret=#{wx_mp_user.app_secret}"
    end

    def get_jsapi_ticket
      return if wx_mp_user.access_token_expired?

      get "cgi-bin/ticket/getticket?access_token=#{wx_mp_user.access_token}&type=jsapi"
    end

  end
end
