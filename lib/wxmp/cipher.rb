module Wxmp
  module Cipher

    KEY = WxmpSetting.app_id
    AES_KEY = WxmpSetting.aes_key
    TOKEN = WxmpSetting.token

    class << self
      def sign(encrypt, nonce = nil, timestamp = nil, token = nil, **options)
        token = token || options[:token] || TOKEN
        nonce = nonce || options[:nonce] || SecureRandom.hex(4)
        timestamp = timestamp || options[:timestamp] || DateTime.now.strftime("%Q")
        encrypt = encrypt || options[:encrypt]

        Wxmp.log_info "Wxmp === sign: token = #{token}, nonce = #{nonce}, timestamp = #{timestamp}, encrypt = #{encrypt}"

        data = [token, nonce, timestamp, encrypt].sort
        sha1 = OpenSSL::Digest::SHA1.new
        signature = sha1.hexdigest(data.join)

        Wxmp.log_info "Wxmp === sign: signature = #{signature}"

        signature
      end

      def jsapi_sign(params = {})
        jsapi_ticket = params[:jsapi_ticket]
        noncestr = params[:noncestr] || SecureRandom.hex(4)
        timestamp = params[:timestamp] || DateTime.now.strftime("%s")
        url = params[:url]
        data = "jsapi_ticket=#{jsapi_ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"

        Wxmp.log_info "Wxmp === jsapi_sign: data = #{data}"

        sha1 = OpenSSL::Digest::SHA1.new
        signature = sha1.hexdigest(data)

        Wxmp.log_info "Wxmp === jsapi_sign: signature = #{signature}"

        signature
      end

      def encrypt(params = {}, key = nil, aes_key = nil)
        return '' unless params.present?

        key = key || KEY
        aes_key = aes_key || AES_KEY

        enc_cipher_aes = OpenSSL::Cipher::AES.new('256-CBC')
        enc_cipher_aes.padding = 0
        enc_cipher_aes.encrypt
        aes_key = Base64.decode64(aes_key)
        enc_cipher_aes.key = aes_key
        enc_cipher_aes.iv = aes_key.slice(0, 16)

        case
          when params.is_a?(String)
            json_data = params
          when params.respond_to?(:to_json)
            json_data = params.to_json
          else
            json_data = params.to_s
        end
        Wxmp.log_info "Wxmp === encrypt: json_data = #{json_data}"

        random_str = SecureRandom.hex 8  # add 16 Bytes random string
        Wxmp.log_info "Wxmp === encrypt: random_str = #{random_str}"

        len_hex_str = Wxmp::Utils::NetworkOrder.int_to_bytes json_data.bytesize # 4 Bytes length
        Wxmp.log_info "Wxmp === encrypt: len_hex_str = #{len_hex_str}"
        Wxmp.log_info "Wxmp === encrypt: len_hex_str byte length = #{len_hex_str.bytesize}"

        data = "#{random_str}#{len_hex_str}#{json_data}#{key}"
        Wxmp.log_info "Wxmp === encrypt: data = #{data}"
        Wxmp.log_info "Wxmp === encrypt: data byte length = #{data.bytesize}"

        Wxmp::Utils::PKCS7Padding.add_padding(data) # add PKCS7 padding

        Wxmp.log_info "Wxmp === encrypt:  encrypt_data = #{data}"
        Wxmp.log_info "Wxmp === encrypt:  encrypt_data byte length = #{data.bytesize}"

        encrypted_data = enc_cipher_aes.update(data) + enc_cipher_aes.final
        encypted_base64_data = Base64.strict_encode64(encrypted_data)
      end

      def decrypt(encrypted_base64_data, key = nil, aes_key = nil)
        return  HashWithIndifferentAccess.new unless encrypted_base64_data.present?

        key = key || KEY
        aes_key = aes_key || AES_KEY

        dec_cipher_aes = OpenSSL::Cipher::AES.new('256-CBC')
        dec_cipher_aes.padding = 0
        dec_cipher_aes.decrypt
        aes_key = Base64.decode64(aes_key)
        dec_cipher_aes.key = aes_key
        dec_cipher_aes.iv = aes_key.slice(0, 16)

        encrypted_data = Base64.decode64(encrypted_base64_data)
        plain_data = dec_cipher_aes.update(encrypted_data) + dec_cipher_aes.final
        Wxmp::Utils::PKCS7Padding.remove_padding(plain_data) # remove PKCS7 padding

        plain_data.slice!(0, 16) # remove 16 Bytes random string
        len = Wxmp::Utils::NetworkOrder.bytes_to_int(plain_data.slice!(0, 4)) # 4 Bytes length
        msg_data = plain_data.slice!(0, len) # Msg
        received_suite_key = plain_data # suite key

        if key == received_suite_key
          begin
            if msg_data.match(/^<xml/)
              HashWithIndifferentAccess.new(Hash.from_xml(msg_data))
            else
              HashWithIndifferentAccess.new(JSON.parse(msg_data))
            end
          rescue
            msg_data
          end
        else
          HashWithIndifferentAccess.new
        end
      end
    end
  end
end
