require 'telegram/bot'
require_relative 'board'
require_relative 'player'

class TelegramBot
  def initialize(token)
    @token = token
    @game_board = GameBoard.new
    @player = Player.new
  end

  def run
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot

      bot.listen do |message|
        case message.text
        when '/start'
          @game_board.reset
          @player.current_player = 'X'
          buttons = (1..9).map { |i| Telegram::Bot::Types::KeyboardButton.new(text: @game_board.board[i-1] == ' ' ? "#{i}" : "_") }
          start_button = Telegram::Bot::Types::KeyboardButton.new(text: "start")
          buttons << start_button
          kb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons.each_slice(3).to_a, resize_keyboard: true)
          @bot.api.send_message(chat_id: message.chat.id, text: "Welcome to Tic Tac Toe! To play Tic Tac Toe, use the buttons below to select the square you want to place your mark. The first player is X, and the second player is O. The goal is to get three of your marks in a row, either horizontally, vertically, or diagonally. Good luck! Use 'start' to start a new game.", reply_markup: kb)
        when '1'..'9'
          index = message.text.to_i - 1
          if @game_board.board[index] == ' '
            @game_board.place_mark(index, @player.current_player)
            @bot.api.send_message(chat_id: message.chat.id, text: @game_board.draw_board)
            winner = @game_board.check_win(@player.current_player)
            if winner
              @bot.api.send_message(chat_id: message.chat.id, text: "Game over! #{winner} wins.")
              @game_board.reset
              @player.current_player = 'X'
            elsif @game_board.is_full
              @bot.api.send_message(chat_id: message.chat.id, text: "Game over! It's a tie.")
              @game_board.reset
              @player.current_player = 'X'
            else
              @player.switch_player
              if @player.current_player == 'O'
                @game_board.play_ai
                @bot.api.send_message(chat_id: message.chat.id, text: @game_board.draw_board)
                winner = @game_board.check_win(@player.current_player)
                if winner
                  @bot.api.send_message(chat_id: message.chat.id, text: "Game over! #{winner} wins.")
                  @game_board.reset
                  @player.current_player = 'X'
                elsif @game_board.is_full
                  @bot.api.send_message(chat_id: message.chat.id, text: "Game over! It's a tie.")
                  @game_board.reset
                  @player.current_player = 'X'
                else
                  @player.switch_player
                end
              end
            end
          else
            @bot.api.send_message(chat_id: message.chat.id, text: "Invalid move. That square is already taken.")
          end
        else
          @bot.api.send_message(chat_id: message.chat.id, text: "Sorry, I didn't understand that command.")
        end
      end
    end
    end
    end
    bot = TelegramBot.new('6289524174:AAF7pMeCGJA_J2vePhxc32C4K6j2wYEw2gc')
    bot.run
