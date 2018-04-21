class CreateWxMpUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :wx_mp_users do |t|
      t.string :name
      t.string :app_id
      t.string :app_secret
      t.string :token
      t.string :aes_key
      t.string :access_token, limit: 1000
      t.datetime :access_token_expired_at
      t.string :jsapi_ticket, limit: 1000
      t.datetime :jsapi_ticket_expired_at

      t.timestamps
    end

  end
end
