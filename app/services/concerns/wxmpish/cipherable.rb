module Wxmpish
  module Cipherable
    extend ActiveSupport::Concern

    def encrypt(data, key = nil, aes_key = nil, **options)
      key = key || options[:key]
      aes_key = aes_key || options[:aes_key]

      Wxmp::Cipher.encrypt(data, key, aes_key)
    end

    def decrypt(encrypt_data, key = nil, aes_key = nil)
      key = key || options[:key]
      aes_key = aes_key || options[:aes_key]

      Wx::Cipher.decrypt(encrypt_data, key, aes_key)
    end

    def sign(encrypt, nonce = nil, timestamp = nil, **options)
      token = cipher.token
      nonce = nonce || options[:nonce] || SecureRandom.hex(4)
      timestamp = timestamp || options[:timestamp] || DateTime.now.strftime("%Q")
      encrypt = encrypt || options[:encrypt]

      Wxmp::Cipher.sign(encrypt, nonce, timestamp, token, options)
    end

    def jsapi_sign(ticket, url, noncestr, timestamp)
      params = {
        jsapi_ticket: ticket,
        url: url,
        noncestr: noncestr || SecureRandom.hex(4),
        timestamp: timestamp || DateTime.now.strftime("%s")
      }

      Wxmp.log_info "Wxmp === jsapi_sign: params = #{params}"
      signature = Wxmp::Cipher.jsapi_sign(params)
      Wxmp.log_info "Wxmp === jsapi_sign: signature = #{signature}"

      signature
    end
  end
end
