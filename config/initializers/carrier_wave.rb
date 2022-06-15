if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_public = false
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      # ローカルプリコンパイルで個々の設定が入りそう→これがないとpuroduction環境でコンパイルができない
      aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
      region: Rails.application.credentials.dig(:aws, :s3_region),
    }
    config.fog_directory = Rails.application.credentials.dig(:aws, :s3_bucket)
    config.asset_host = Rails.application.credentials.dig(:aws, :s3_host)
  end
end
