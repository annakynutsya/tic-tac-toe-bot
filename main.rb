require 'telegram/bot'

Telegram::Bot::Client.run('6289524174:AAF7pMeCGJA_J2vePhxc32C4K6j2wYEw2gc') do |bot|
  game_board = [' '] * 9
  current_player = 'X'

  def draw_board(board)
    "#{board[0].tr(' ', '1')}  #{board[1].tr(' ', '2')} #{board[2].tr(' ', '3')}
#{board[3].tr(' ', '4')}  #{board[4].tr(' ', '5')}  #{board[5].tr(' ', '6')}
#{board[6].tr(' ', '7')}  #{board[7].tr(' ', '8')}  #{board[8].tr(' ', '9')}
"
  end

  def check_win(board)
    wins = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    wins.each do |win|
      return board[win[0]] if board[win[0]] == board[win[1]] && board[win[1]] == board[win[2]] && board[win[0]] != ' '
    end
    nil
  end

  def play_ai(board, current_player)
    x = rand(0..2)
    y = rand(0..2)

    if board[x + (y * 3)] == ' '
      board[x + (y * 3)] = current_player
      true
    else
      play_ai(board, current_player)
    end
  end

  bot.listen do |message|
    case message.text
    when '/start'
      game_board = [' '] * 9
      current_player = 'X'
      buttons = (1..9).map { |i| Telegram::Bot::Types::KeyboardButton.new(text: game_board[i-1] == ' ' ? "#{i}" : "_") }
      start_button = Telegram::Bot::Types::KeyboardButton.new(text: "start")
      buttons << start_button
      kb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons.each_slice(3).to_a, resize_keyboard: true)

      bot.api.send_message(chat_id: message.chat.id, text: "Welcome to Tic Tac Toe! To play Tic Tac Toe, use the buttons below to select the square you want to place your mark. The first player is X, and the second player is O. The goal is to get three of your marks in a row, either horizontally, vertically, or diagonally. Good luck! Use 'start' to start a new game.", reply_markup: kb)
    when '1'..'9'
      index = message.text.to_i - 1
      if game_board[index] == ' '
        game_board[index] = current_player
        bot.api.send_message(chat_id: message.chat.id, text: draw_board(game_board))
        winner = check_win(game_board)
        if winner
          bot.api.send_message(chat_id: message.chat.id, text: "Game over! #{winner} wins.")
          game_board = [' '] * 9
          current_player = 'X'
        elsif game_board.all? { |square| square != ' ' }
          bot.api.send_message(chat_id: message.chat.id, text: "Game over! It's a tie.")
          game_board = [' '] * 9
          current_player = 'X'
        else
          current_player = current_player == 'X' ? 'O' : 'X'
          if current_player == 'O'
            play_ai(game_board, current_player)
            bot.api.send_message(chat_id: message.chat.id, text: draw_board(game_board))
            winner = check_win(game_board)
            if winner
              bot.api.send_message(chat_id: message.chat.id, text: "Game over! #{winner} wins.")
              game_board = [' '] * 9
              current_player = 'X'
            elsif game_board.all? { |square| square != ' ' }
              bot.api.send_message(chat_id: message.chat.id, text: "Game over! It's a tie.")
              game_board = [' '] * 9
              current_player = 'X'
            else
              current_player = 'X'
            end
          end
        end
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Invalid move. That square is already taken.")
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I didn't understand that command.")
    end
  end
end
