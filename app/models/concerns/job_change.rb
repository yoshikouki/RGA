require 'active_support/concern'
# Player のレベルアップ処理
module JobChange
  extend ActiveSupport::Concern

  # 現在ジョブのインスタンスを返す
  def current_job
    job_levels.find_by(job_id: current_job_id)
  end

  # ジョブチェンジ可能なリストを返す
  def changeable_job_list
    job_levels.map(&:job) + inexperienced_changeable_jobs
  end

  # 転職経験のないジョブのリスト（転職可能だがjob_levelsにレコードがないジョブ）
  def inexperienced_changeable_jobs
    inexperienced_jobs = Job.all.excluding(job_levels.map(&:job))
    inexperienced_jobs.map do |target_job|
      target_job if target_job.changeable_job?(job_levels)
    end.compact
  end

  # ジョブチェンジが正当なものか判断する
  # 引数 job_change_list: { current_job_id: :int, target_job_id: :int }
  def valid_job_change?(target_job)
    target_job.changeable_job?(job_levels)
  end

  # 現在のジョブを変更する
  def change_job(target_job)
    job_levels.find_or_create_by(job_id: target_job.id)
    update(current_job_id: target_job.id)
  end
end
