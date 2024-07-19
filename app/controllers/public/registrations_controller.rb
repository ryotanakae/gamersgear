class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def after_sign_up_path_for(resource)
    root_path
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: "アカウントが作成されました。"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
