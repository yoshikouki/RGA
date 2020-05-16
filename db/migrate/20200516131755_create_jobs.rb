class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :job_name
      t.integer :level_limit

      t.timestamps
    end
  end
end
