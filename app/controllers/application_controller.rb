class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先を定義
  def after_sign_in_path_for(resource)
    root_path
  end

  private

  # 非ログインユーザーが、ログイン必須なアクセスをした場合の処理
  def sign_in_required
    redirect_to(new_user_session_url) unless user_signed_in?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
