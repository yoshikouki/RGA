class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :user_id
      t.string :name
      t.string :lv
      t.string :hp
      t.string :str
      t.string :vit

      t.timestamps
    end
  end
end
