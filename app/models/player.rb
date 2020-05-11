# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  def initialize(params)
    # params ||= { name: 'マダオ', lv: 1, hp: 50, str: 200, vit: 10 }
    super(params)
  end
end
