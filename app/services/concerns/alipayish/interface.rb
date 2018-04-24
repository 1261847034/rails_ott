module Alipayish
  module Interface
    extend ActiveSupport::Concern

    def prepare_params(opts = {})
      params = {
        format: "JSON",
        charset: "utf-8",
        sign_type: "RSA2",
        timestamp: DateTime.now.strftime("%F %T"),
        version: "1.0"
      }.merge(opts.deep_symbolize_keys)

      params.merge!(app_id: AlipaySetting.app_id) unless params.has_key?(:app_id)
      params.merge(sign: sign(params))
    end

    # 活动创建
    def campaign_activity_create(params = {})
      params.merge!(method: "koubei.marketing.campaign.activity.create")

      post "gateway.do", prepare_params(params)
    end

    # 活动人群数据上传
    def data_enterprise_staffinfo_upload(params = {})
      params.merge!(method: "koubei.marketing.data.enterprise.staffinfo.upload")

      post "gateway.do", prepare_params(params)
    end

    # 活动下架
    def campaign_activity_offline(params = {})
      params.merge!(method: "koubei.marketing.campaign.activity.offline")

      post "gateway.do", prepare_params(params)
    end

    # 活动详情查询
    def campaign_activity_query(params = {})
      params.merge!(method: "koubei.marketing.campaign.activity.query")

      post "gateway.do", prepare_params(params)
    end

    # 口碑权益发放
    def campaign_benefit_send(params = {})
      params.merge!(method: "koubei.marketing.campaign.benefit.send")

      post "gateway.do", prepare_params(params)
    end

    # 上传门店照片和视频
    def alipay_offline_material_image_upload(params = {})
      params.merge!(method: "alipay.offline.material.image.upload")

      post "gateway.do", prepare_params(params)
    end

    # ISV 查询商户列表
    def tool_isv_merchant_query(params = {})
      params.merge!(method: "koubei.marketing.tool.isv.merchant.query")

      post "gateway.do", prepare_params(params)
    end

    def alipay_system_oauth_token(params = {})
      params.merge!(method: "alipay.system.oauth.token")

      post "gateway.do", prepare_params(params)
    end

    def alipay_user_info_share(params = {})
      params.merge!(method: "alipay.user.info.share")

      post "gateway.do", prepare_params(params)
    end

    def alipay_open_auth_token_app(params = {})
      params.merge!(method: "alipay.open.auth.token.app")

      post "gateway.do", prepare_params(params)
    end

    def alipay_open_auth_token_app_query(params = {})
      params.merge!(method: "alipay.open.auth.token.app.query")

      post "gateway.do", prepare_params(params)
    end

    def test(params = {})
      post "gateway.do", prepare_params(params)
    end

  end
end
