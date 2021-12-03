# 全ての環境で/seeds/base.rbを読み込む
load(Rails.root.join('db/seeds/base.rb'))
# Rails の環境に合わせて読み込むseedsファイルを切り替える
# load(Rails.root.join('db/seeds', "#{Rails.env.downcase}.rb"))
