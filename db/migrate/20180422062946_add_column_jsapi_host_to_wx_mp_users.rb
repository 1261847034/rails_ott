class AddColumnJsapiHostToWxMpUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :wx_mp_users, :jsapi_host, :string
  end
end
