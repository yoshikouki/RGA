# ジョブチェンジの条件を定義するマスター
class JobChangeCondition < ApplicationRecord
  belongs_to :job
end
