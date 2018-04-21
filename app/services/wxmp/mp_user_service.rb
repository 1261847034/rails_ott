module Wxmp
  class MpUserService

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

    def event_listener(data)
      Wxmp.log_info "Wxmp === event_listener: #{data.inspect}"
      return data if data.is_a?(String)

      result = 'success'

      result
    end
  end
end
