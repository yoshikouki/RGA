# Jobのマスターデータ
class Job < ApplicationRecord
  # nullifi:JobModelの削除次、job_levels.job_idはnullになる
  has_many :job_levels, dependent: :nullify
end
