class CreateWxUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :wx_users do |t|
      t.references :wx_mp_user, index: true
      t.string :openid
      t.string :unionid
      t.string :nickname
      t.integer :sex
      t.string :province
      t.string :city
      t.string :country
      t.string :headimgurl
      t.datetime :subscribe_time
      t.boolean :subscribe

      t.timestamps
    end

    add_index :wx_users, [:wx_mp_user_id, :unionid], unique: true
  end
end
