class CreateJobChangeConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_change_conditions do |t|
      t.bigint :job_id
      t.bigint :condition_job_id
      t.bigint :condition_job_level

      t.timestamps
    end
  end
end
