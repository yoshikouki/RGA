class RemoveJobExpFromJobLevels < ActiveRecord::Migration[6.0]
  def change
    remove_column :job_levels, :job_exp, :bigint
  end
end
