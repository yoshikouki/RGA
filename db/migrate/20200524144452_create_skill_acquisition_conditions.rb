class CreateSkillAcquisitionConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_acquisition_conditions do |t|
      t.bigint :skill_id
      t.bigint :condition_job_id
      t.bigint :condition_job_level

      t.timestamps
    end
  end
end
