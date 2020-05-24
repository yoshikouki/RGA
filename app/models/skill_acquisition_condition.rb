# スキル習得のための条件マスター
class SkillAcquisitionCondition < ApplicationRecord
  belongs_to :skill
  belongs_to :job
end
