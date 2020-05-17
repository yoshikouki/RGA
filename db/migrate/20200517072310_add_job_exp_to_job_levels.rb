class AddJobExpToJobLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :job_levels, :job_exp, :bigint
  end
end
