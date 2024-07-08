class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :action, presence: true
  belongs_to :recipient, class_name: 'User', foreign_key: 'user_id'
end
