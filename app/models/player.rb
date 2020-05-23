# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  belongs_to :user
  has_many :job_levels, dependent: :destroy

  # new, create, find(インスタンス化) 後に実行
  after_initialize :set_params
  after_create :to_create_job_level

  attr_accessor :lv_up_diff,
                :next_lv_exp

  with_options presence: true do
    with_options numericality: { only_integer: true } do
      validates :lv
      validates :exp
      validates :hp
      validates :str
      validates :vit
      validates :coin
      validates :current_job_id
    end
    with_options uniqueness: { case_sensitive: false } do
      validates :user_id
      validates :name, length: { maximum: 50 }
    end
  end

  # #new でステータスが nil の場合は初期値で上書き
  def initialize(params)
    params = params ? params.reverse_merge(INIT_PARAMS) : INIT_PARAMS
    super(params)
  end

  # インスタンス化するたびにパラメータを設定
  def set_params
    self.current_hp = hp
    self.next_lv_exp = calculate_exp_to_lv_up(lv + 1) - exp
  end

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
    current_job.decision_level_up(@lv_up_diff)
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
  # 引数 job_change_list: { current_job_id: :int, after_job_id: :int }
  def valid_job_change?(target_job)
    target_job.changeable_job?(job_levels)
  end

  # 現在のジョブを変更する
  def change_job(job_list)
    job_id = job_list[:after_job_id]
    job_levels.find_or_create_by(job_id: job_id)
    update(current_job_id: job_id)
  end

  private

  def to_create_job_level
    job_levels.create
  end

  INIT_PARAMS = {
    name:           'init_player',
    lv:             1,
    exp:            0,
    hp:             100,
    str:            10,
    vit:            10,
    coin:           0,
    current_job_id: 1,
    lv_up_diff:     0
  }.freeze

  NEXT_LV_EXP_DIFF = 2
end
