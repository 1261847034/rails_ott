class WxmpSetting < Settingslogic
  source "#{Rails.root}/config/wxmp.yml"
  namespace Rails.env
end