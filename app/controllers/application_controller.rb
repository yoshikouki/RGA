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
    redirect_to(introduction_path) unless user_signed_in?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:username])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:username])
  end

  def set_var
    @bootstrap_class_list = BOOTSTRAP_CLASS_LIST.deep_dup
    return unless user_signed_in?

    @player = current_user.player
    job_name = Job.find(@player.current_job_id).job_name
    @current_job = @player.current_job
                          .attributes.symbolize_keys
                          .merge!(job_name: job_name)
  end

  BOOTSTRAP_CLASS_LIST = {
    page_title:          'h4 mb-5',
    form:                'my-5',
    form_group:          'form-group mb-3',
    form_field:          'form-control',
    form_submit:         'btn btn-block btn-primary font-weight-bold mt-5 py-4',
    form_small_text:     'form-text small text-gray',
    link_list:           '',
    link_list_btn:       'btn btn-secondary mb-3',
    link_list_btn_block: 'btn btn-light btn-block mb-3',
    link_list_text:      'small mb-2',
    link_btn_secondary:  'btn btn-secondary mb-3',
    form_errors:         'mb-5',
    form_errors_title:   'h5',
    form_errors_lists:   'list-group',
    form_errors_list:    'list-group-item list-group-item-dark py-1'
  }.freeze
end
