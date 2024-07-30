class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :create_notification

  validates :body, presence: true

  private
    def create_notification
      Notification.create(
        user: user,
        recipient: post.user,
        action: 'comment',
        notifiable: self
      ) unless user == post.user
    end
    
    def destroy_related_notifications
      Notification.where(notifiable_id: id, notifiable_type: 'PostComment').destroy_all
    end
  
end
