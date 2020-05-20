class AddIndexToJobLevels < ActiveRecord::Migration[6.0]
  def change
    add_index :job_levels, [:player_id, :job_id], unique: true
  end
end
