class ApplicationController < ActionController::Base
  # ログイン後のリダイレクト先を定義
  def after_sign_in_path_for(resource)
    root_path
  end

  private

    # 非ログインユーザーが、ログイン必須なアクセスをした場合の処理
    def sign_in_required
      redirect_to(new_user_session_url) unless user_signed_in?
    end
end
