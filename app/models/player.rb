# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

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
