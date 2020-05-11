# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

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
    end
    with_options uniqueness: { case_sensitive: false } do
      validates :user_id
      validates :name, length: { maximum: 50 }
    end
  end

  def initialize(params)
    params = params ? params.reverse_merge(INIT_PARAMS) : INIT_PARAMS
    super(params)
  end

  # 獲得したEXPとコインを保存
  # params[:get_exp, :get_coin]
  def earn_reward(**params)
    update(exp:  self.exp += params[:get_exp],
           coin: self.coin += params[:get_coin])
    self
  end

  def decision_level_up
    if exp >= (lv + 1)**2
      lv_diff = calculate_lv_diff
      grow_status(lv_diff)
      { lv_upped: { lv_diff:   lv_diff,
                    after_lv:  lv,
                    after_hp:  hp,
                    after_str: str,
                    after_vit: vit } }
    else { lv_upped: false }; end
  end

  def calculate_lv_diff
    next_lv_diff = 1
    loop do
      next_lv_diff += 1
      break if exp < (lv + next_lv_diff)**2
    end
    (next_lv_diff - 1)
  end

  def grow_status(lv_diff)
    update(lv:  self.lv += lv_diff,
           hp:  self.hp += lv_diff,
           str: self.str += lv_diff,
           vit: self.vit += lv_diff)
  end

  INIT_PARAMS = {
    name: 'init_player',
    lv:   1,
    exp:  0,
    hp:   100,
    str:  10,
    vit:  10,
    coin: 0
  }.freeze
end
