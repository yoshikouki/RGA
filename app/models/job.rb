# Jobのマスターデータ
class Job < ApplicationRecord
  # nullifi:JobModelの削除次、job_levels.job_idはnullになる
  has_many :job_levels, dependent: :nullify
  has_many :job_change_conditions, dependent: :nullify

  # プレイヤーがジョブチェンジ可能かどうか判定する
  # 引数： @player.job_levels
  def changeable_job?(player_job_levels)
    return false unless job_change_conditions

    decision_for_changeable = job_change_conditions.map do |condition|
      break [false] unless (job_info = player_job_levels.find_by(job_id: condition.condition_job_id))

      job_info.job_level >= condition.condition_job_level
    end
    decision_for_changeable.exclude?(false)
  end
end
