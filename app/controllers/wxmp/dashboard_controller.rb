class Wxmp::DashboardController < Wxmp::BaseController

  before_action :find_wx_mp_user

  def index
    @service = Wxmp::JsapiService.new
    @jsapi_config = @service.generate_config(request.fullpath)
  end

  def home
    if params[:code].blank? && !micro_messenger_browser?
      return redirect_to root_path
    end

    if params[:code].blank?
      redirect_to_authorize
    else
      Wxmp.log_info "params = #{params}"
      render json: {code: 1}
    end

  end

  def redirect_to_authorize
    opts = {
      appid: @wx_mp_user.app_id,
      redirect_uri: home_redirect_uri,
      response_type: 'code',
      scope: 'snsapi_userinfo',
      state: 'STATE'
    }

    url = URI("https://open.weixin.qq.com/connect/oauth2/authorize")
    url.query = opts.to_query
    url.fragment = 'wechat_redirect'
    @url = url.to_s
    Wxmp.log_info "authorize url: #{@url}"
    redirect_to @url
  end

  def find_wx_mp_user
    @wx_mp_user = WxMpUser.find_by(id: params[:id])
  end

  def home_redirect_uri
    opts = {
      id: @wx_mp_user.id
    }

    url = URI(@wx_mp_user.authorize_host)
    url.path = '/wxmp/home'
    url.query = opts.to_query
    url.to_s
    # URI.encode_www_form_component(url.to_s)
  end

end