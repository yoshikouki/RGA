class Job < ApplicationRecord
  has_many :job_levels, dependent: :nullify  # JobModelの削除次、job_levels.job_idはnullになる
end
