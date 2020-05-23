class AddCurrentJobIdToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :current_job_id, :integer
  end
end
