if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_public = false

    # AWSの設定
    config.fog_provider = 'AWS'
    config.fog_directory = Rails.application.credentials.dig(:aws, :s3_bucket)
    config.fog_region = Rails.application.credentials.dig(:aws, :s3_region)
    config.aws_access_key_id = Rails.application.credentials.dig(:aws, :access_key_id)
    config.aws_secret_access_key = Rails.application.credentials.dig(:aws, :secret_access_key)

    # EC2に設定しているrolesからIDとkeyを取得
    # config.aws_iam_roles = true

    # 元ファイルをそのまま残す
    config.existing_remote_files = 'keep'
    config.gzip_compression = true

    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')

    # webpackerに対応
    config.run_on_precompile = false

    config.add_local_file_paths do
      public_root = Rails.root.join('public')
      Dir.chdir(public_root) do
        packs_dir = Webpacker.config.public_output_path.relative_path_from(public_root)
        Dir[File.join(packs_dir, '/**/**')]
      end
    end
  end
end
