class Chessboard < ApplicationRecord

  START_BOARD_FEN = Chess::Game.new.current.to_fen

  def self.for_player(player)
    board = Chessboard.find_by(player: player)
    if board.nil?
      board = Chessboard.new(
        player: player,
        state: START_BOARD_FEN
      )
    end
    board
  end

  def reset
    update(
      state: START_BOARD_FEN,
      selected_square: nil
    )
  end

  def game
    @game ||= Chess::Game.load_fen(state)
  end

  def move_from(square)
    self.selected_square = square
  end

  def move_to(square)
    game.move2(self.selected_square, square, nil)
    self.state = game.current.to_fen
  end

  def ai_move
    engine = Stockfish::Engine.new('./vendor/stockfish')
    ai_move = Stockfish::AnalysisParser.new(
      engine.analyze(game.current.to_fen, {depth: 2})
    ).best_move_uci
    [ai_move[0..1], ai_move[2..3]]
  end
end
