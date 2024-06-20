class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # フォローされている関連付け
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # フォロワーの取得
  has_many :followers, through: :passive_relationships, source: :follower
  # フォローしている関連付け
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  #  フォローしている人の取得
  has_many :following, through: :active_relationships, source: :followed

  validates :name, presence: true

  has_one_attached :image

  def get_image
    image.attached? ? image : 'no_image.jpg'
  end

  # フォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  #　フォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしているかの確認
  def following?(user)
    following.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      where("name LIKE ?", word).where(is_active: true)
    elsif search == "partial_match"
      where("name LIKE ?", "%#{word}%").where(is_active: true)
    else
      where("name LIKE ?", "%#{word}%").where(is_active: true)  # デフォルトは部分一致
    end
  end

  # ゲストユーザー機能
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_update :deactivate_user, if: :deactivating?

  private

  # is_activeがfalseになる場合に呼ばれるメソッド
  def deactivate_user
    posts.destroy_all
    post_comments.destroy_all
    likes.destroy_all
    passive_relationships.destroy_all
    active_relationships.destroy_all
  end

  # is_activeがfalseに変更されるかどうかをチェックするメソッド
  def deactivating?
    is_active_changed? && !is_active
  end

end
