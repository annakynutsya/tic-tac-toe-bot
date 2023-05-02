class Player
  attr_accessor :current_player

  def initialize
    @current_player = 'X'
  end

  def switch_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def check_winner(board)
    return 'X' if board.check_win('X')
    return 'O' if board.check_win('O')
    return nil
  end
end
