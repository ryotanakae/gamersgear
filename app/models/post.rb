class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_one_attached :image
  validates :title, :body, :category_id, presence: true
  # numericarity starが数値であることを確認
  # greater_than_orequal_to: 0 starが0以上であることを確認
  # less_than_or_equal_to: 5 starが5以下であることを確認
  validates :star, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def get_image
    image.attached? ? image : 'default-image.jpg'
  end

  #　いいね機能 指定されたユーザーがいいねしているかを確認
  def likes_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 検索機能 タイトルと本文から
  def self.looks(search, word)
    if search == "perfect_match"
      # 完全一致
      where("title LIKE ? OR body LIKE ?", word, word)
    elsif search == "partial_match"
      # 部分一致
      where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      # デフォルトは部分一致
      where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    end
  end
  
end
