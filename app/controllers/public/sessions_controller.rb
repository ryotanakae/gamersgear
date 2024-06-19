class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]
  
  def after_sign_in_path_for(resource)
    root_path
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  

  private
  # 会員ステータスがアクティブか判断するためのメソッド
  def user_state
    # 入力されたメールアドレスからアカウントを1件取得
    user = User.find_by(email: params[:user][:email])
    # アカウントを取得できなかった場合、このメソッドを終了する
    return if user.nil?
    # 取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
    return unless user.valid_password?(params[:user][:password])
    # アクティブでない会員に対する処理
    if user.is_active == true
    else
      redirect_to new_user_session_path, notice: "退会済みです"
    end
  end
  
end
