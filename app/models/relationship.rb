class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: "follower_id"
  belongs_to :followed, class_name: "User", foreign_key: "followed_id"
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :create_notification

  # 同じユーザーが同じユーザーを複数回フォローできないように制限する記述
  validates :follower_id, uniqueness: { scope: :followed_id }

  private
    def create_notification
      followed.create_notification("follow", self)
    end
end
