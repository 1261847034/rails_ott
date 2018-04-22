class WxMpUser < ApplicationRecord

  has_many :wx_users

  def access_token_expired?
    expired = self.access_token_expired_at.present? ? DateTime.now >= self.access_token_expired_at : true
    if access_token.blank? or expired
      update_access_token
    end

    DateTime.now >= self.access_token_expired_at
  end

  def update_access_token
    service = Wxmp::MpUserService.new self
    data = service.get_access_token
    if data.present?
      expired_at = DateTime.now + data[:expires_in].seconds - 5.minutes
      update(
        access_token: data[:access_token],
        access_token_expired_at: expired_at
      )
    end
  end

  def jsapi_ticket_expired?
    expired = self.jsapi_ticket.present? ? DateTime.now >= self.jsapi_ticket_expired_at : true
    if jsapi_ticket.blank? or expired
      update_jsapi_ticket
    end

    DateTime.now >= self.jsapi_ticket_expired_at
  end

  def update_jsapi_ticket
    service = Wxmp::MpUserService.new self
    data = service.get_jsapi_ticket
    if data.present?
      expired_at = DateTime.now + data[:expires_in].seconds - 5.minutes
      update(
        jsapi_ticket: data[:ticket],
        jsapi_ticket_expired_at: expired_at
      )
    end
  end

end
