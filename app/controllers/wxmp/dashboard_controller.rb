class Wxmp::DashboardController < Wxmp::BaseController

  def home
    Wxmp.log_info "request.user_agent.to_s = #{request.user_agent.to_s}"
  end

end