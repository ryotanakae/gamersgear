class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    
    case notification.notifiable_type
    when "Like"
      redirect_to post_path(notification.notifiable.post)
    when "PostComment"
      redirect_to post_path(notification.notifiable.post)
    when "Relationship"
      redirect_to user_path(notification.notifiable.follower)
    else
      redirect_to root_path, alert: "通知の種類が不明です"
    end
  end
  
  def destroy_all
    current_user.notifications.destroy_all
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # destroy_all.js.erb を呼び出す
    end
  end
  
end
