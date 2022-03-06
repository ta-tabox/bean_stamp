# Rails の環境に合わせて読み込むseedsファイルを切り替える
if Rails.env.downcase == 'development'
  load(Rails.root.join('db/seeds', "#{Rails.env.downcase}.rb"))
end
# 全ての環境で/seeds/base.rbを読み込む
load(Rails.root.join('db/seeds/base.rb'))

# seed-fu gemの実行
SeedFu.seed
