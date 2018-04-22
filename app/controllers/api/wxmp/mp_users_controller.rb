class Api::Wxmp::MpUsersController < Api::Wxmp::BaseController

  before_action :find_wx_mp_user

  def callback
    Wxmp.log_info "Wxmp === api callback: params = #{params}"

    unless validate_signature?
      Wxmp.log_info "Wxmp === validate signature failure: params = #{params}"
      return render plain: 'failure'
    end

    if params[:echostr].present?
      return render plain: params[:echostr]
    end

    encrypt = params[:xml][:Encrypt]
    data = @service.decrypt(encrypt, @wx_mp_user.app_id, @wx_mp_user.aes_key)
    Wxmp.log_info "Wxmp === Decrypted data: #{data}"

    unless validate_msg_signature?(encrypt)
      Wxmp.log_info "Wxmp === validate msg signature failure: data = #{data}, params = #{params}"
      return render plain: 'failure'
    end

    result = @service.event_listener(data)

    render plain: result || 'failure'
  end

  private

  def find_wx_mp_user
    @wx_mp_user = WxMpUser.find_by(id: params[:id])
    @service = Wxmp::MpUserService.new(@wx_mp_user)
  end

  def validate_signature?
    Wxmp.log_info "Wxmp === Received signature = #{params[:signature]}"
    return false unless @wx_mp_user.present?

    @service.sign("", params[:nonce], params[:timestamp], token: @wx_mp_user.token) === params[:signature]
  end

  def validate_msg_signature?(encrypt)
    Wxmp.log_info "Wxmp === Received signature = #{params[:msg_signature]}"
    return false unless @wx_mp_user.present?

    @service.sign(encrypt, params[:nonce], params[:timestamp], token: @wx_mp_user.token) === params[:msg_signature]
  end

end
