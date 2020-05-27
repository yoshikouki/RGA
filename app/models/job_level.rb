# プレイヤーの各ジョブに関するモデル
class JobLevel < ApplicationRecord
  belongs_to :player
  belongs_to :job

  after_initialize :set_params

  attr_accessor :job_level_up_diff,
                :job_name,
                :next_job_level_exp

  validates :player_id, uniqueness: { scope: :job_id }

  def initialize(params)
    init_params = { job_id:    1,
                    job_level: 1 }
    params = params ? params.reverse_merge(init_params) : init_params
    super(params)
  end

  # インスタンス化するたびにパラメータを設定
  def set_params
    @job_name = job.job_name
  end

  # ジョブレベルアップの処理
  def decision_level_up(level_up_diff)
    return if reached_in_level_limit?

    # ジョブのレベルアップ処理
    calculate_job_level_up_diff(level_up_diff).grow_job_status
    self
  end

  # ジョブがレベル上限に達していればtrue
  def reached_in_level_limit?
    job_level >= job.level_limit
  end

  # ジョブレベルが上限を超えてレベルアップしないか確認した上で、クラス変数定義
  def calculate_job_level_up_diff(level_up_diff)
    limit_diff = job.level_limit - (job_level + level_up_diff)
    @job_level_up_diff = limit_diff.negative? ? job.level_limit - job_level : level_up_diff
    self
  end

  # ジョブレベルを上昇させる
  def grow_job_status
    update(job_level: self.job_level += @job_level_up_diff)
  end
end
