module Alipay
  module Cipher
    class << self

      def params_to_string(params = {})
        params.deep_stringify_keys.sort.map{|item| item.join('=') }.join('&')
      end

      def sign(data, sign_type = nil, key = nil, **options)
        opts = HashWithIndifferentAccess.new(data)

        key = key || AlipaySetting.app_private_key
        sign_type = sign_type || options[:sign_type] || opts[:sign_type]

        send("#{sign_type.to_s.underscore}_sign", data, key)
      end

      def rsa_sign(data, key = nil)
        key = key || AlipaySettings.app_private_key
        str = data.is_a?(Hash) ? params_to_string(data) : data

        Alipay.log_info "Alipay === rsa sign: key = #{key}, str = #{str}"

        key = Base64.decode64(key)
        rsa = OpenSSL::PKey::RSA.new(key)
        signature = rsa.sign('sha1', str)
        signature = Base64.strict_encode64(signature)

        Alipay.log_info "Alipay === rsa sign: signature = #{signature}"

        signature
      end

      def rsa2_sign(data, key = nil)
        key = key || AlipaySetting.app_private_key
        str = data.is_a?(Hash) ? params_to_string(data) : data

        Alipay.log_info "Alipay === rsa2 sign: key = #{key}, str = #{str}"

        key = Base64.decode64(key)
        rsa = OpenSSL::PKey::RSA.new(key)
        signature = rsa.sign('sha256', str)
        signature = Base64.strict_encode64(signature)

        Alipay.log_info "Alipay === rsa2 sign: signature = #{signature}"

        signature
      end

      def verify?(data, sign_type = nil, sign = nil, key = nil, **options)
        params = HashWithIndifferentAccess.new(data)

        key = key || options[:key] || AlipaySetting.alipay_public_key
        sign = sign || options[:sign] || params.delete(:sign)
        sign_type = sign_type || options[:sign_type] || params.delete(:sign_type)

        data = params if data.is_a?(Hash)
        send("#{sign_type.to_s.underscore}_verify?", data, sign, key)
      end

      def rsa_verify?(data, sign, key = nil)
        string = data.is_a?(Hash) ? params_to_string(data) : data
        key = key || Settings::Kb.alipay_public_key

        Alipay.log_info "Alipay === rsa verify: key = #{key}, str = #{string}, sign = #{sign}"

        key = Base64.decode64(key)
        rsa = OpenSSL::PKey::RSA.new(key)
        rsa.verify('sha1', Base64.strict_decode64(sign), string)
      end

      def rsa2_verify?(data, sign, key = nil)
        string = data.is_a?(Hash) ? params_to_string(data) : data
        key = key || AlipaySetting.alipay_public_key

        Alipay.log_info "Alipay === rsa2 verify: key = #{key}, str = #{string}, sign = #{sign}"

        key = Base64.decode64(key)
        rsa = OpenSSL::PKey::RSA.new(key)
        rsa.verify('sha256', Base64.strict_decode64(sign), string)
      end

    end
  end
end
