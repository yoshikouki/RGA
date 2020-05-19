# プレイヤー情報の変更リクエストなどを処理する
class PlayersController < ApplicationController
  def job_change
    if @player.valid_job_change?(job_change_params)
      # ＋もしJob Levels がなかった場合は作成する
      @player.change_job(job_change_params)
      flash[:success] = 'ジョブチェンジしました'
    else
      flash[:danger] = '不正なジョブチェンジです'
    end
    redirect_to root_path
  end

  private

  def job_change_params
    params.require(:job_change_list).permit(:current_job_id, :after_job_id)
  end
end
