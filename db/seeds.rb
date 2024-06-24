# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: ENV['ADMIN_EMAIL'],password: ENV['ADMIN_PASSWORD'])

# Kani = User.find_or_create_by!(email: "kani@kani") do |user|
#   user.name = "かに"
#   user.password = "000000"
#   user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/kani.png"), filename:"kani.jpg")
# end