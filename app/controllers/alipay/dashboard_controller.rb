class Alipay::DashboardController < Alipay::BaseController

  def index
  end

  def authorization
    case params[:auth_type]
      when "app_to_app_auth"
        app_to_app_auth
      when "public_app_authorize"
        public_app_authorize
    end
  end

  # 第三方应用授权(商户账号)
  def app_to_app_auth
    if params[:app_auth_code].blank?
      opts = {
        app_id: AlipaySetting.app_id,
        redirect_uri: app_to_app_auth_redirect_uri, # 与应用的授权回调地址必须一致
      }

      url = URI("#{AlipaySetting.openauth_host}/oauth2/appToAppAuth.htm")
      url.query = opts.to_query

      Alipay.log_info "app_to_app_auth url: #{url.to_s}"

      redirect_to url.to_s
    else
      Rails.logger.info "request.referrer: #{request.headers.inspect}, #{request.referer.inspect}, #{request.env['HTTP_REFERER'].inspect}"

      service = Alipay::TestService.new
      data = service.user_info_by_app_auth_code(params[:app_auth_code])

      render json: data
    end
  end

  def app_to_app_auth_redirect_uri
    opts = {
      auth_type: "app_to_app_auth"
    }
    url = URI(AlipaySetting.callback_host)
    url.path = '/alipay/authorization'
    url.query = opts.to_query
    url.to_s
  end

  def public_app_authorize
    if params[:auth_code].blank?
      opts = {
        app_id: AlipaySetting.app_id,
        redirect_uri: public_app_authorize_redirect_uri,
        scope: "auth_user,auth_base,auth_ecard,auth_invoice_info,auth_puc_charge",
        state: "STATE"
      }

      url = URI("#{AlipaySetting.openauth_host}/oauth2/publicAppAuthorize.htm")
      url.query = opts.to_query

      Alipay.log_info "public_app_authorize url: #{url.to_s}"

      redirect_to url.to_s
    else
      Rails.logger.info "request.referrer: #{request.headers.inspect}, #{request.referer.inspect}, #{request.env['HTTP_REFERER'].inspect}"

      service = Alipay::TestService.new
      data = service.user_info_by_auth_code(params[:auth_code])

      render json: data
    end
  end

  def public_app_authorize_redirect_uri
    opts = {
      auth_type: "public_app_authorize"
    }
    url = URI(AlipaySetting.callback_host)
    url.path = '/alipay/authorization'
    url.query = opts.to_query
    url.to_s
  end

end