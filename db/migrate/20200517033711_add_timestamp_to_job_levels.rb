class AddTimestampToJobLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :job_levels, :created_at, :datetime, { precision: 6, null: false }
    add_column :job_levels, :updated_at, :datetime, { precision: 6, null: false }
  end
end
