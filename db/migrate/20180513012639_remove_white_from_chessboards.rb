class RemoveWhiteFromChessboards < ActiveRecord::Migration[5.1]
  def change
    remove_column :chessboards, :white, :boolean
  end
end
