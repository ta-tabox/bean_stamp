# 前回の画像を削除
FileUtils.rm_r('public/uploads/user/image') if Dir.exist?('public/uploads/user/image')
FileUtils.rm_r('public/uploads/roaster/image') if Dir.exist?('public/uploads/roaster/image')
FileUtils.rm_r('public/uploads/bean_image/image') if Dir.exist?('public/uploads/bean_image/image')
