module Alipayish
  module Errorable
    extend ActiveSupport::Concern

    SUCCESS_CODE = 10000

    included do
      attr_accessor :err_res, :err_key
    end

    def error
      res = HashWithIndifferentAccess.new(@err_res)
      return unless @err_res
      return if res[@err_key][:code].to_i == SUCCESS_CODE

      res
    end

  end
end
