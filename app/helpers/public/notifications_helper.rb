module Public::NotificationsHelper
  def notification_message(notification)
    case notification.notifiable_type
    when "Like"
      "#{notification.notifiable.user.name}さんがあなたの投稿にいいねしました"
    when "PostComment"
      "#{notification.notifiable.user.name}さんがあなたの投稿にコメントしました"
    when "Relationship"
      "#{notification.notifiable.follower.name}さんがあなたをフォローしました"
    else
      "新しい通知があります"
    end
  end
end
