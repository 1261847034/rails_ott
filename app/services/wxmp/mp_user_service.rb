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

    def msg_type_listener(data)
      Wxmp.log_info "Wxmp === event_listener: #{data.inspect}"
      return data if data.is_a?(String)

      xml = data[:xml]
      return unless xml[:ToUserName].eql?(@wx_mp_user.uid)

      result = case xml[:MsgType]
        when "event"
          event_listener(data)
        when "text"
          msg_type_text(data)
      end

      result || 'success'
    end

    def msg_type_text(data)

    end

    def event_listener(data)
      case data[:xml][:event]
        when "subscribe"
          event_subscribe(data)
        when "unsubscribe"
          event_unsubscribe(data)
      end
    end

    def event_subscribe(data)
      xml = data[:xml]

      openid = xml[:FromUserName]
      data = get_user_info(openid)
      return if data.blank?

      attrs = {
        wx_mp_user: @wx_mp_user,
        openid: openid,
        unionid: data[:unionid],
        nickname: data[:nickname],
        sex: data[:sex],
        province: data[:province],
        city: data[:city],
        country: data[:country],
        headimgurl: data[:headimgurl],
        subscribe_time: Time.at(data[:subscribe_time].to_i),
        subscribe: true
      }

      wx_user = @wx_mp_user.wx_users.find_or_initialize_by(unionid: attrs[:openid])
      wx_user.update(attrs)
    rescue => e
      unless e.is_a?(ActiveRecord::RecordNotUnique)
        Wxmp.log_error "Wxmp === event subscribe failure: data = #{data}, error: #{e.message}"
        e.backtrace.each { |msg| Wxmp.log_error msg }
      end
    end

    def event_unsubscribe(data)
      xml = data[:xml]

      wx_user = @wx_mp_user.wx_users.find_by(openid: xml[:FromUserName])
      wx_user.update(subscribe: false)
    end

  end
end
