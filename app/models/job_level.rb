# プレイヤーの各ジョブに関するモデル
class JobLevel < ApplicationRecord
  belongs_to :player
  belongs_to :job

  attr_accessor :job_level_up_diff

  # 獲得した経験値をジョブEXPに反映
  def earn_reward(reward)
    return self if reached_in_level_limit?

    earned_exp = job_exp + reward[:get_exp]
    limit_exp = calculate_exp_to_level_up(job.level_limit)
    update(job_exp: earned_exp >= limit_exp ? limit_exp : earned_exp)
    self
  end

  # ジョブがレベル上限に達していればtrue
  def reached_in_level_limit?
    job_exp >= calculate_exp_to_level_up(job.level_limit)
  end

  # レベルアップするための経験値を計算
  def calculate_exp_to_level_up(level)
    level**NEXT_LV_EXP_DIFF
  end

  # ジョブレベルが上がっているか判定する
  def level_upped?
    job_exp >= calculate_exp_to_level_up(job_level + 1)
  end

  # ジョブレベルアップの処理
  def decision_level_up
    return false unless level_upped? || !reached_in_level_limit?

    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if job_exp < calculate_exp_to_level_up(job_level + next_lv_diff)
    end
    @job_level_up_diff = (next_lv_diff - 1)
    grow_job_status
    self
  end

  def grow_job_status
    update(job_level: self.job_level += @job_level_up_diff)
  end

  NEXT_LV_EXP_DIFF = 2
end
