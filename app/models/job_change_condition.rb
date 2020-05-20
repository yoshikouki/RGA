# ジョブチェンジの条件を定義するマスター
class JobChangeCondition < ApplicationRecord
  belongs_to :job

  def changeable_job_list(**job_list)
    # job_list.each do |l|
    #   l.job_id
    #   l.job_level
    # end
    # [{ job_name: '', id: 1 },]
  end
end
