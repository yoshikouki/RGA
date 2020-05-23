class CreateJobLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :job_levels do |t|
      t.bigint :player_id
      t.integer :job_id
      t.bigint :job_level
    end
  end
end
