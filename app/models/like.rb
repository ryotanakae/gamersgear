class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 同じユーザーが一つの投稿に複数回できないように制限
  validates :user_id, uniqueness: { scope: :post_id }
end
