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
      str = "<xml>
        <ToUserName><![CDATA[#{data[:xml][:FromUserName]}]]></ToUserName>
        <FromUserName><![CDATA[#{@wx_mp_user.uid}]]></FromUserName>
        <CreateTime>#{DateTime.now.to_i}</CreateTime>
        <MsgType><![CDATA[text]]></MsgType>
        <Content><![CDATA[你好]]></Content>
      </xml>"

      nonce = SecureRandom.hex(4)
      timestamp = DateTime.now.strftime("%Q")
      msg_encrypt = encrypt(str, @wx_mp_user.app_id, @wx_mp_user.aes_key)
      msg_signature = sign(msg_encrypt, nonce, timestamp, token: @wx_mp_user.token)

      "<xml>
        <Encrypt><![CDATA[#{msg_encrypt}]]></Encrypt>
        <MsgSignature><![CDATA[#{msg_signature}]]></MsgSignature>
        <TimeStamp>#{timestamp}</TimeStamp>
        <Nonce><![CDATA[#{nonce}]]></Nonce>
      </xml>"
    end

    def event_listener(data)
      case data[:xml][:Event]
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

      Wxmp.log_info "data :#{data}"

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
      wx_user.update(subscribe: false) if wx_user
    end

  end
end
