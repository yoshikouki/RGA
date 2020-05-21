# ジョブチェンジの条件を定義するマスター
class JobChangeCondition < ApplicationRecord
  belongs_to :job

  def changeable_job_list(job_levels)
    # 未転職ジョブ（JobLevelsにない）をリスト化する
    inexperienced_jobs = Job.all.excluding(job_levels.map(&:job))
    # 未転職ジョブの条件を引っ張り出す
    # 未転職ジョブ毎に条件を満たしているか判定する
    # 転職条件を満たしているジョブリストを作る
    # ジョブリストを返す
    inexperienced_jobs.map do |target_job|
      target_job if job_changeable?(target_job, job_levels)
    end.compact
  end

  # ジョブレベルがターゲット職の条件を満たしていたら true
  # 引数 job_levels: { current_job_id: :int, after_job_id: :int }
  def job_changeable?(target_job, job_levels)
    conditions = target_job.job_change_conditions
    decision_for_changeable = Array(conditions).map do |condition|
      break [false] unless (job = job_levels.find_by(job_id: condition.condition_job_id))

      job.job_level >= condition.condition_job_level
    end
    decision_for_changeable.exclude?(false)
  end
end
