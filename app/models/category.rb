class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  def self.looks(search, word)
    if search == "perfect_match"
      where("name LIKE ?", word)
    elsif search == "partial_match"
      where("name LIKE ?", "%#{word}%")
    else
      where("name LIKE ?", "%#{word}%")  # デフォルトは部分一致
    end
  end
  
  validates :name, presence: true
end
