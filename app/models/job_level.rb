# プレイヤーの各ジョブに関するモデル
class JobLevel < ApplicationRecord
  belongs_to :player
  belongs_to :job

  attr_accessor :job_level_up_diff

  end

  # 獲得した経験値をジョブEXPに反映
  def earn_reward(reward)
    update(job_exp: self.job_exp += reward[:get_exp])
    self
  end

  # ジョブレベルが上がっているか判定する
  def level_upped?
    job_exp >= (job_level + 1)**2
  end

  # ジョブレベルアップの処理
  def decision_level_up
    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if job_exp < (job_level + next_lv_diff)**NEXT_LV_EXP_DIFF
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
