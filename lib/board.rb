class GameBoard
  attr_accessor :board

  def initialize
    @board = [' '] * 9
  end

  def draw_board
    "#{board[0].tr(' ', '1')}  #{board[1].tr(' ', '2')} #{board[2].tr(' ', '3')}
#{board[3].tr(' ', '4')}  #{board[4].tr(' ', '5')}  #{board[5].tr(' ', '6')}
#{board[6].tr(' ', '7')}  #{board[7].tr(' ', '8')}  #{board[8].tr(' ', '9')}
    "
  end

  def play_ai
    empty_indices = board.each_index.select { |i| board[i] == ' ' }
    index = empty_indices.sample
    place_mark(index, 'O')
  end

  def place_mark(index, mark)
    @board[index] = mark
  end

  def check_win(player)
    wins = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    wins.each do |win|
      return board[win[0]] if board[win[0]] == board[win[1]] && board[win[1]] == board[win[2]] && board[win[0]] != ' '
    end
    nil
  end

  def is_full
    return board.all? { |square| square != ' ' }
  end

  def reset
    @board = [' '] * 9
  end
end
