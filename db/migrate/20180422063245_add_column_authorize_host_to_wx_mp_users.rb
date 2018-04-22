class AddColumnAuthorizeHostToWxMpUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :wx_mp_users, :authorize_host, :string
  end
end
