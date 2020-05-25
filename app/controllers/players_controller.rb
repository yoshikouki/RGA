# プレイヤー情報の変更リクエストなどを処理する
class PlayersController < ApplicationController
  before_action :sign_in_required

  def jobs; end

  def job_change
    target_job = Job.find(job_change_params[:target_job_id].to_i)
    if @player.valid_job_change?(target_job)
      # ＋もしJob Levels がなかった場合は作成する
      @player.change_job(target_job)
      flash[:success] = 'ジョブチェンジしました'
    end
    redirect_to root_path
  rescue StandardError
    flash[:danger] = '不正なジョブチェンジです'
    redirect_to root_path
  end

  def skills; end

  private

  def job_change_params
    params.require(:job_change_list).permit(:current_job_id, :target_job_id)
  end
end
