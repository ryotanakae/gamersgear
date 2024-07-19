class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :create_notification

  # 同じユーザーが一つの投稿に複数回できないように制限
  validates :user_id, uniqueness: { scope: :post_id }

  private
    def create_notification
      post.user.create_notification("like", self) unless user == post.user
    end
end
