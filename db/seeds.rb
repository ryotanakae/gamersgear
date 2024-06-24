# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: ENV['ADMIN_EMAIL'],password: ENV['ADMIN_PASSWORD'])

users = [
  { email: "kame@kame", name: "かめ", password: "000000", introduction: "かめです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/kame.png", filename: "kame.jpg" },
  { email: "ebi@ebi", name: "えび", password: "000000", introduction: "えびです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/ebi.png", filename: "ebi.jpg" },
  { email: "ika@ika", name: "いか", password: "000000", introduction: "いかです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/ika.png", filename: "ika.jpg" },
  { email: "wani@wani", name: "わに", password: "000000", introduction: "わにです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/wani.png", filename: "wani.jpg" },
  { email: "unagi@unagi", name: "うなぎ", password: "000000", introduction: "うなぎです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/unagi.png", filename: "unagi.jpg" },
  { email: "tako@tako", name: "たこ", password: "000000", introduction: "たこです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/tako.png", filename: "tako.jpg" },
  { email: "hirame@hirame", name: "ひらめ", password: "000000", introduction: "ひらめです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/hirame.png", filename: "hirame.jpg" },
  { email: "maguro@maguro", name: "まぐろ", password: "000000", introduction: "まぐろです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/maguro.png", filename: "maguro.jpg" },
  { email: "tokage@tokage", name: "トカゲ", password: "000000", introduction: "トカゲです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/tokage.png", filename: "tokage.jpg" },
  { email: "zarigani@zarigani", name: "ザリガニ", password: "000000", introduction: "ザリガニです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/zarigani.png", filename: "zarigani.jpg" },
  { email: "hebi@hebi", name: "ヘビ", password: "000000", introduction: "ヘビです　ゲームが好きです", image_path: "#{Rails.root}/db/fixtures/hebi.png", filename: "hebi.jpg" }
]

users.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.password = user_data[:password]
    user.introduction = user_data[:introduction]
  end

  unless user.image.attached?
    user.image.attach(io: File.open(user_data[:image_path]), filename: user_data[:filename])
  end
end

categories = [
  { name: "キーボード" },
  { name: "マウス" },
  { name: "モニター" },
  { name: "ヘッドホン" },
  { name: "イヤホン" },
  { name: "マウスパッド" },
  { name: "ゲームパッド" },
  { name: "マイク" }
]

categories.each do |category_data|
  Category.find_or_create_by!(name: category_data[:name])
end

posts = [
  { title: "キーボード", body: "使いやすくておすすめのキーボードです。", user_email: "tako@tako", category_name: "キーボード", star: 5, image_path: "#{Rails.root}/db/fixtures/tkeybord.jpg" },
  { title: "マウス", body: "初心者でも使いやすいマウスです。", user_email: "kame@kame", category_name: "マウス", star: 4, image_path: "#{Rails.root}/db/fixtures/tmouse.jpg" },
  { title: "モニター", body: "とてもクリアに映ります。", user_email: "ebi@ebi", category_name: "モニター", star: 4.5, image_path: "#{Rails.root}/db/fixtures/tmonitor.jpg" },
  { title: "ヘッドホン", body: "非常に音質がよく音楽にもゲームにも使えます。", user_email: "ika@ika", category_name: "ヘッドホン", star: 3, image_path: "#{Rails.root}/db/fixtures/theadphone.jpg" },
  { title: "マウスパッド", body: "誰にでも使いやすいおすすめのマウスパッドだと思います。。", user_email: "wani@wani", category_name: "マウスパッド", star: 4.5, image_path: "#{Rails.root}/db/fixtures/tmousepad.jpg" },
  { title: "ゲームパッド", body: "持ちやすく、とてもゲームが快適です。", user_email: "hebi@hebi", category_name: "ゲームパッド", star: 4, image_path: "#{Rails.root}/db/fixtures/tpad.jpg" },
  { title: "マイク", body: "音質が良くおすすめのマイクです。", user_email: "maguro@maguro", category_name: "マイク", star: 3.5, image_path: "#{Rails.root}/db/fixtures/tmike.jpg" },
  { title: "キーボード2", body: "押し心地のいいキーボードです", user_email: "tokage@tokage", category_name: "キーボード", star: 4.5, image_path: "#{Rails.root}/db/fixtures/tkeybord2.jpg" },
]

posts.each do |post_data|
  user = User.find_by(email: post_data[:user_email])
  category = Category.find_by(name: post_data[:category_name])

  if user && category
    post = Post.find_or_create_by!(title: post_data[:title], user: user, category: category) do |post|
      post.body = post_data[:body]
      post.star = post_data[:star]
    end

    unless post.image.attached?
      post.image.attach(io: File.open(post_data[:image_path]), filename: File.basename(post_data[:image_path]))
    end
  end
end