class AlipaySetting < Settingslogic
  source "#{Rails.root}/config/alipay.yml"
  namespace Rails.env
end