module Alipayish
  module Errorable
    extend ActiveSupport::Concern

    SUCCESS_CODE = 10000

    included do
      attr_accessor :err_res
    end

    def error
      res = HashWithIndifferentAccess.new(@err_res)
      res
    end

  end
end
