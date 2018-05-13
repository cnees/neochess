class CreateChessboards < ActiveRecord::Migration[5.1]
  def change
    create_table :chessboards do |t|
      t.string :player, null: false
      t.index :player, unique: true
      t.text :state
      t.boolean :white, default: true, null: false
      t.timestamps
    end
  end
end
