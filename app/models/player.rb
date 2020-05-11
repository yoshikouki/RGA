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
