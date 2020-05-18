# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  belongs_to :user
  has_many :job_levels, dependent: :destroy

  # new, create, find 後に実行
  # Module #initialize ではfindで実行されない
  after_initialize :set_current_hp
  after_create :to_create_job_level

  attr_accessor :lv_up_diff

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

  # 獲得したEXPとコインを保存
  # params[:get_exp, :get_coin]
  # 戻り値：自インスタンス
  def earn_reward(**params)
    update(exp:  self.exp += params[:get_exp],
           coin: self.coin += params[:get_coin])
    self
  end

  # レベルアップしているかを確認し、していればステータスなどを加算する
  # 戻り値：レベルアップの数値（int）
  def decision_lv_up
    return false unless lv_upped?

    calculate_lv_diff.grow_status
  end

  # Playerレベルが上っているかどうかを判断する
  def lv_upped?
    (exp >= (lv + 1)**NEXT_LV_EXP_DIFF)
  end

  # 現在の経験値がどのレベルに当たるかを計算する
  # 戻り値：自インスタンス
  def calculate_lv_diff
    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if exp < (lv + next_lv_diff)**NEXT_LV_EXP_DIFF
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
    job_levels.find(current_job_id)
  end

  private

  def to_create_job_level
    init_job_level = {
      job_id:    current_job_id,
      job_level: 1,
      job_exp:   0
    }
    job_levels.create(init_job_level)
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
