class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def initialize(*)
    super
    return unless Rails.env.production?

    self.asset_host = Rails.application.credentials.dig(:aws, :s3_host)
  end

  # 保存ディレクトリ
  def store_dir
    if model.present?
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      # modelに紐つかないファイルはuploads/直下に保存
      'uploads/content_image/'
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # デフォルト画像の設定/app/assets/images/fallback/default.pngとして配置する
  # def default_url(*_args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   ActionController::Base.helpers.asset_path(
  #     "fallback/#{[version_name, 'default.png'].compact.join('_')}",
  #   )
  # end

  # リサイズ
  process resize_to_fit: [800, 800]

  # thumb用のバージョン image.thumb.urlで表示できる
  version :thumb do
    process resize_to_fit: [300, 300]
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # アップロードできるサイズ
  def size_range
    1..5.megabytes
  end

  def url
    if path.present?
      # 保存先がローカルの場合
      return "#{super}?updatedAt=#{model.updated_at.to_i}" if Rails.env.development? || Rails.env.test?

      # 保存先がS3の場合
      return "#{asset_host}/#{store_dir}/#{identifier}?updatedAt=#{model.updated_at.to_i}"
    end

    super
  end
end