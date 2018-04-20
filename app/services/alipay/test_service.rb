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
  end
end
