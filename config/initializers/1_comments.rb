class Comments < Settingslogic
  source "#{Rails.root}/config/comments.yml"
  namespace Rails.env
end
