# SES用の設定
ses_creds = Aws::Credentials.new(
  Rails.application.credentials.dig(:aws, :ses_username),
  Rails.application.credentials.dig(:aws, :ses_password),
)

Aws::Rails.add_action_mailer_delivery_method(
  :ses,
  credentials: ses_creds,
  region: Rails.application.credentials.dig(:aws, :ses_region),
)
