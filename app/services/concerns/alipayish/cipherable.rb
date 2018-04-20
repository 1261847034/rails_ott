module Alipayish
  module Cipherable
    extend ActiveSupport::Concern

    def sign(data, sign_type = nil, key = nil, **options)
      params = HashWithIndifferentAccess.new(data)

      key = key || options[:key]
      sign_type = sign_type || options[:sign_type] || params[:sign_type]

      Alipay::Cipher.sign(data, sign_type, key, options)
    end

    def verify?(data, sign_type = nil, sign = nil, key = nil, **options)
      params = HashWithIndifferentAccess.new(data)

      key = key || options[:key]
      sign = sign || options[:sign] || params.delete(:sign)
      sign_type = sign_type || options[:sign_type] || params.delete(:sign_type)

      data = params if data.is_a?(Hash)
      Alipay::Cipher.verify?(data, sign_type, sign, key, options)
    end

  end
end
