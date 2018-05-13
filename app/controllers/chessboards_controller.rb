class ChessboardsController < ApplicationController

  def petpage
    render 'chessboards/petpage'
  end

  def svg
    @letter_pieces = letter_pieces
    board = Chessboard.for_player(player)
    path = get_path(request)
    if valid_square?(path)
      @square = path
      if board.selected_square?
        begin
          board.move_to(@square)
          @ai_from, @ai_to = board.ai_move
          board.move_from(@ai_from)
          board.move_to(@ai_to)
          board.selected_square = @square = nil
        rescue Chess::IllegalMoveError
          puts "--Illegal move: #{board.selected_square} to #{@square}--"
          board.move_from(@square)
        end
      else
        board.move_from(@square)
      end
    elsif path == 'reset'
      board.reset
    end
    board.save
    game = Chess::Game.load_fen(board.state)
    @board = game.current
    if game.over?
      @message = "Game over! #{game.status}"
    end
    render('chessboards/board', formats: [:svg])
  end

  def get_path(request)
    referer_path = request.env['HTTP_REFERER'] || 'http://neopets.com/b2/~0F0'
    start = "neopets.com/"
    finish = "/~"
    referer_path[/#{start}(.*?)#{finish}/m, 1] || ''
  end

  def valid_square?(square)
    square.match(/^[A-H|a-h][1-8]$/).present?
  end

  def player
    @player ||= request.remote_ip.to_s
  end

  def letter_pieces
    {
      'K' => '&#9812;',
      'Q' => '&#9813;',
      'R' => '&#9814;',
      'B' => '&#9815;',
      'N' => '&#9816;',
      'P' => '&#9817;',
      'k' => '&#9818;',
      'q' => '&#9819;',
      'r' => '&#9820;',
      'b' => '&#9821;',
      'n' => '&#9822;',
      'p' => '&#9823;',
    }
  end
end
