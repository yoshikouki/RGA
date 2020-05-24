# プレイヤーが習得したスキルを管理
class AcquiredSkill < ApplicationRecord
  belongs_to :player
  belongs_to :skill
end
