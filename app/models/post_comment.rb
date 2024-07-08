class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  
  after_create :create_notification
  
  validates :body, presence: true
  
  private

  def create_notification
    post.user.create_notification('comment', self) unless user == post.user
  end
  
end
