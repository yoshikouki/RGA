class JobLevel < ApplicationRecord
  belongs_to :player
  belongs_to :job

  # 獲得した経験値をジョブEXPに反映
  def earn_reward(get_exp)
    update(job_exp: self.job_exp += get_exp)
  end
end
