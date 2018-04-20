module Wxmp
  def self.logger
    @logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new("#{Rails.root}/log/wxmp.log"))
  end

  def self.log_info(msg, uuid: nil)
    uuid ||= RequestStore.store[:request_uuid]
    logger.tagged(Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), uuid) {
      logger.info msg
    }
  end

  def self.log_error(msg, uuid: nil)
    uuid ||= RequestStore.store[:request_uuid]
    logger.tagged(Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), uuid) {
      logger.error msg
    }
  end
end
