class Api::Wxmp::MpUsersController < Api::Wxmp::BaseController

  before_action :find_wx_mp_user

  def callback
    Wx.log_info "Wxmp === api callback: params = #{params}"

    render text: 'failure'
  end

  private

    def find_wx_mp_user
      @wx_mp_user = WxMpUser.find_by(id: params[:id])
      @service = Wxmp::MpUserService.new(@wx_mp_user)
    end

end
