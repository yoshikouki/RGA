class AcquiredSkill < ApplicationRecord
  belongs_to :player
  belongs_to :skill
end
