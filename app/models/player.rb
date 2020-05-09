require './app/models/character'

# ゲーム用ユーザーデータ
class Player < ApplicationRecord
  include Character

  def initialize(params)
    super(params)
  end
end
