class JobLevel < ApplicationRecord
  belongs_to :player, :jobs
end
