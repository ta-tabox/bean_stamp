if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_public = false
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      region: Rails.application.credentials.dig(:aws, :s3_region),     # 例: 'ap-northeast-1'
      use_iam_profile: true,
    }
    config.fog_directory = Rails.application.credentials.dig(:aws, :s3_bucket)
  end
end
