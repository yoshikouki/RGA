# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  def initialize(params)
    params ||= INIT_PARAMS
    super(params)
  end

  INIT_PARAMS = {
    name: 'マダオ',
    lv:   1,
    exp:  0,
    hp:   50,
    str:  200,
    vit:  10,
    coin: 0
  }.freeze
end
