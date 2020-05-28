require 'active_support/concern'
# Player のレベルアップ処理
module LevelUp
  extend ActiveSupport::Concern

  # 獲得したEXPとコインを保存
  # params[:get_exp, :get_coin]
  # 戻り値：自インスタンス
  def earn_reward(**params)
    update(exp:  self.exp += params[:get_exp],
           coin: self.coin += params[:get_coin])
    self
  end

  # レベルアップしているかを確認し、していればステータスなどを加算する
  def decision_lv_up
    return false unless lv_upped?

    calculate_lv_diff.grow_status
    unless @lv_up_diff.zero?
      current_job.decision_level_up(@lv_up_diff)
      acquire_skill
    end
    self
  end

  # Playerレベルが上っているかどうかを判断する
  def lv_upped?
    exp >= calculate_exp_to_lv_up(lv + 1)
  end

  # レベルアップするための経験値を計算
  def calculate_exp_to_lv_up(level)
    level**NEXT_LV_EXP_DIFF
  end

  # 現在の経験値がどのレベルに当たるかを計算する
  # 戻り値：自インスタンス
  def calculate_lv_diff
    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if exp < calculate_exp_to_lv_up(lv + next_lv_diff)
    end
    @lv_up_diff = (next_lv_diff - 1)
    self
  end

  # 上がったレベルに応じてステータスを加算する。
  # 戻り値：なし
  def grow_status
    update(lv:  self.lv += @lv_up_diff,
           hp:  self.hp += @lv_up_diff,
           str: self.str += @lv_up_diff,
           vit: self.vit += @lv_up_diff)
  end

  # レベルに応じたスキルを獲得する
  def acquire_skill
    unacquired_skills = current_job.job
                            .skill_acquisition_conditions
                            .where("condition_job_level <= #{current_job.job_level}")
                            .map(&:skill)
                            .excluding(acquired_skills.map(&:skill))
    unacquired_skills&.map do |skill|
      acquired_skills.create(skill_id: skill.id)
    end
  end

  NEXT_LV_EXP_DIFF = 2
end
