class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_one_attached :image
  validates :title, :body, :category_id, presence: true
  # numericarity starが数値であることを確認
  # greater_than_orequal_to: 0 starが0以上であることを確認
  # less_than_or_equal_to: 5 starが5以下であることを
  validates :star, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def get_image
    image.attached? ? image : 'default-image.jpg'
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      where("title LIKE ? OR body LIKE ?", word, word)
    elsif search == "partial_match"
      where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")  # デフォルトは部分一致
    end
  end
  
end
