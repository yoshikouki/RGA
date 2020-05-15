class AddIndexPlayersUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :players, :user_id, unique: true
    add_index :players, :name, unique: true
  end
end
