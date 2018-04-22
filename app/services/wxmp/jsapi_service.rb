module Wxmp
  class JsapiService

    attr_reader :wx_mp_user

    include Wxmpish::Cipherable
    include Wxmpish::Httpable
    include Wxmpish::Interface

    def initialize(wx_mp_user = nil)
      @wx_mp_user = wx_mp_user

      unless @wx_mp_user
        @wx_mp_user = WxMpUser.find_by(app_id: WxmpSetting.app_id)
      end
    end

    def generate_config(fullpath)
      return {} if wx_mp_user.jsapi_ticket_expired?
      wx_mp_user.reload

      timestamp = DateTime.now.strftime("%s")
      nonce_str = SecureRandom.hex(4)
      request_url = "#{wx_mp_user.callback_url_host}#{fullpath}"
      signature = jsapi_sign(wx_mp_user.jsapi_ticket, request_url, nonce_str, timestamp)

      {
        app_id: wx_mp_user.app_id,
        time_stamp: timestamp,
        nonce_str: nonce_str,
        signature: signature,
        expired_at: wx_mp_user.jsapi_ticket_expired_at
      }
    end

  end
end
