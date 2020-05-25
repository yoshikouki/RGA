class RenameConditionJobIdColumnToSkillAcquisitionConditions < ActiveRecord::Migration[6.0]
  def change
    rename_column :skill_acquisition_conditions, :condition_job_id, :job_id
  end
end
