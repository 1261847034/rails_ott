module Wxmpish
  module Httpable
    extend ActiveSupport::Concern

    HTTParty::Basement.default_options.update(verify: false)

    HOST = WxmpSetting.api_host
    CODE = 0
    STATUS = 200

    def get(path)
      url = URI.escape("#{HOST}/#{path}")
      start_time = Time.now
      res = HTTParty.get url
      exec_time = Time.now - start_time
      Wxmp.log_info "get_data: url: #{url}, exec time: #{exec_time}, response = #{res}, body = #{res.body}"

      unless res.code.to_i == STATUS
        return HashWithIndifferentAccess.new
      end

      data = res.body
      data = JSON.parse(data) if data.is_a? String

      unless data["code"].to_i == CODE
        return HashWithIndifferentAccess.new
      end

      HashWithIndifferentAccess.new data
    end

    def post(path, params)
      url = URI.escape("#{HOST}/#{path}")
      start_time = Time.now
      res = HTTParty.post(url, body: params)
      exec_time = Time.now - start_time
      Wxmp.log_info "post_json: url: #{url}, exec time: #{exec_time}, response = #{res.inspect}, body = #{res.body.inspect}, params = #{params.inspect}"

      unless res.code.to_i == STATUS
        return HashWithIndifferentAccess.new
      end

      data = res.body
      data = JSON.parse(data) if data.is_a? String

      unless data["code"].to_i == CODE
        return HashWithIndifferentAccess.new
      end

      HashWithIndifferentAccess.new data
    end

  end
end