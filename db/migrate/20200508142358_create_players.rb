class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.bigint :user_id
      t.string :name
      t.bigint :lv
      t.bigint :exp
      t.bigint :hp
      t.bigint :str
      t.bigint :vit
      t.bigint :coin

      t.timestamps
    end
  end
end
