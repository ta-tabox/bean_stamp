if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_public = false
    config.fog_provider = 'AWS'
    config.fog_directory = Rails.application.credentials.dig(:aws, :s3_bucket)
    config.fog_region = Rails.application.credentials.dig(:aws, :s3_region)
    # config.aws_access_key_id = Rails.application.credentials.dig(:aws, :access_key_id)
    # config.aws_secret_access_key = Rails.application.credentials.dig(:aws, :secret_access_key)

    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')
    config.aws_iam_roles = true

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
