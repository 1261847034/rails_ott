module Alipay
  class TestService

    include Alipayish::Cipherable
    include Alipayish::Httpable
    include Alipayish::Interface
    include Alipayish::Errorable

    def downloadurl_query
      params = {
        method: 'alipay.data.dataservice.bill.downloadurl.query',
        biz_content: {
          bill_type: 'trade',
          bill_date: '2016-04-01'
        }.to_json(ascii_only: true)
      }

      test(params)
    end

    def user_info_by_app_auth_code(code)
      opts = {
        biz_content: {
          grant_type: "authorization_code",
          code: code
        }.to_json
      }

      data = alipay_open_auth_token_app(opts)
      return {} if data.blank?

      alipay_open_auth_token_app_query({
        app_auth_token: data[:app_auth_token],
        biz_content: { app_auth_token: data[:app_auth_token] }.to_json
      })
    end

    def user_info_by_auth_code(code)
      opts = {
        grant_type: "authorization_code",
        code: code
      }

      data = alipay_system_oauth_token(opts)
      return {} if data.blank?

      alipay_user_info_share({ auth_token: data[:access_token] })
    end

  end
end
