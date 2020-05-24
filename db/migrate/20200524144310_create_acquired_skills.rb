class CreateAcquiredSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :acquired_skills do |t|
      t.bigint :player_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
