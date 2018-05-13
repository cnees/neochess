class AddSelectedSquareToChessboards < ActiveRecord::Migration[5.1]
  def change
    add_column :chessboards, :selected_square, :string
  end
end
