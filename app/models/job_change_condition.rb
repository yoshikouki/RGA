# ジョブチェンジの条件を定義するマスター
class JobChangeCondition < ApplicationRecord
  belongs_to :job

  def changeable_job_list(**job_list)
    # job_list.each do |l|
    #   l.job_id
    #   l.job_level
    # end
    # [{ job_name: '', id: 1 },]
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
