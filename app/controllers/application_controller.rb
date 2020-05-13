class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_var

  # ログイン後のリダイレクト先を定義
  def after_sign_in_path_for(_resource)
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

  def set_var
    @bootstrap_class_list = BOOTSTRAP_CLASS_LIST.deep_dup
  end

  BOOTSTRAP_CLASS_LIST = {
    page_title:     'h4 mb-5',
    form:           'my-5',
    form_group:     'form-group mb-3',
    form_field:     'form-control',
    form_submit:    'btn btn-block btn-primary font-weight-bold mt-5 py-4',
  }.freeze
end
