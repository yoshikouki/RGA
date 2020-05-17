# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  belongs_to :user
  has_many :job_levels, dependent: :destroy

  # new, create, find 後に実行
  # Module #initializeではfindで実行されない
  after_initialize :set_current_hp

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

  # インスタンス化した際にステータスが nil だった場合は初期値で上書き
  def initialize(params)
    params = params ? params.reverse_merge(INIT_PARAMS) : INIT_PARAMS
    super(params)
  end

  # 獲得したEXPとコインを保存
  # params[:get_exp, :get_coin]
  # 戻り値：自インスタンス
  def earn_reward(**params)
    get_exp = params[:get_exp]
    update(exp:  self.exp += get_exp,
           coin: self.coin += params[:get_coin])
    current_job.earn_reward(get_exp)
    self
  end

  # レベルアップしているかを確認し、していればステータスなどを加算する
  # 戻り値：レベルアップの数値（int）
  def decision_lv_up
    return false if exp < (lv + 1)**2

    lv_up_diff = calculate_lv_diff
    grow_status(lv_up_diff)
    lv_up_diff
  end

  # 現在の経験値がどのレベルに当たるかを計算する
  # 戻り値：レベルアップの数値（int）
  def calculate_lv_diff
    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if exp < (lv + next_lv_diff)**2
    end
    (next_lv_diff - 1)
  end

  # 上がったレベルに応じてステータスを加算する。
  # 戻り値：なし
  def grow_status(lv_diff)
    update(lv:  self.lv += lv_diff,
           hp:  self.hp += lv_diff,
           str: self.str += lv_diff,
           vit: self.vit += lv_diff)
  end

  # 現在ジョブのインスタンスを返す
  def current_job
    job_levels.find(current_job_id)
  end

  INIT_PARAMS = {
    name:           'init_player',
    lv:             1,
    exp:            0,
    hp:             100,
    str:            10,
    vit:            10,
    coin:           0,
    current_job_id: 1
  }.freeze
end
