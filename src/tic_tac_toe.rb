# encoding: UTF-8
require_relative './board'
require_relative './player'
require_relative './aiplayer'

class TicTacToe
    def play
        play = "y"
        # Begin game loop, will play games as long as the user wants to
        while play == "y"
            first = get_first

            b, players = set_up_game(first)

            b = play_a_single_game(b, players)

            display_game_results(b, players)
            
            # Let player choose if they want to play another game
            play = play_again
        end
    end
    def get_first(reader = Reader, writer = Writer)
        writer.ask_for_first
        first = reader.read_first_letter
        return first if ["y", "n"].include?(first)
        get_first(reader, writer)
    end
    def set_up_game(first)
        # Initialize the board and players
        b = Board.new
        players = Array.new
        if first == "y"
            players.push(Player.new(:X))
            players.push(AIPlayer.new(:O))
        else
            players.push(AIPlayer.new(:X))
            players.push(Player.new(:O))
        end
        return b, players
    end
    def play_a_single_game(b, p, writer = Writer, player_reader = Player::Reader, player_writer = Player::Writer)
        # Begin loop for a single game
        # Continues until there is a winner or a tie 
        turn = 0
        while b.winner == :none
            cur_player = p[turn%2]
            if cur_player.is_a? AIPlayer
                writer.say_ai_turn
            end
            writer.display_board(b)
            # If the player is a human, prompts for response
            # If the player is AI, selects best move
            r, c = 
                if cur_player.is_a? Player
                    cur_player.get_move(b.board_state, player_reader, player_writer)
                else
                    cur_player.get_move(b)
                end
            b.make_move(r, c)
            turn += 1
            writer.add_spacing
        end #end single game loop
        return b
    end
    def display_game_results(b, p, writer = Writer)
        writer.display_board(b)
        champ = b.winner
        if champ == :tie
            writer.say_tie
        elsif p[0].is_a?(Player) && champ == :X || 
              p[1].is_a?(Player) && champ == :O
            writer.say_win
        else 
            writer.say_lost
        end    
    end
    def play_again(reader = Reader, writer = Writer)
        writer.ask_for_play_again
        play = reader.read_first_letter
        return play if ["y", "n"].include?(play)
        play_again(reader, writer)
    end
    class Writer
        def self.ask_for_first(o_stream = $stdout)
            o_stream.puts "Would you like to go first (y or n)?"
        end
        def self.ask_for_play_again(o_stream = $stdout)
            o_stream.puts "Would you like to play again?(y or n)"
        end
        def self.say_ai_turn(o_stream = $stdout)
            o_stream.puts "AIPlayer's turn"
        end
        def self.add_spacing(o_stream = $stdout)
            o_stream.puts "\n\n"
        end
        def self.say_tie(o_stream = $stdout)
            o_stream.puts "It was a tie!"
        end
        def self.say_win(o_stream = $stdout)
            o_stream.puts "You won!!!"
        end
        def self.say_lost(o_stream = $stdout)
            o_stream.puts "You lost."
        end
        # Returns a string display of the board, including cell
        # numbers to make selecting moves easier for the user
        def self.display_board(b, o_stream = $stdout)
            def self.get_row_display(row_arr, row_num)
                x = ["╲ ╱",
                     " ╳ ",
                     "╱ ╲"]
                o =  ["┌─┐",
                      "│ │",
                      "└─┘"]
                n = ["   ", 
                     "   ", 
                     "  "]
                row = Array.new
                0.upto(2) do |col|
                    if row_arr[col] == :X
                        row.push(x)
                    elsif row_arr[col] == :O
                        row.push(o)
                    else
                        row.push(n)
                    end
                end
                row_display = ""
                0.upto(2) do |line|
                    0.upto(2) do |col|
                        row_display << row[col][line] + 
                                       if line == 2 && row[col] == n then (row_num*3 + col).to_s else "" end + 
                                       col_end(col)
                    end
                end
                row_display
            end
            def self.col_end(col)
                if col == 2
                    "\n"
                else
                    "┃"
                end
            end
            retval = ""
            div = "━━━╋━━━╋━━━\n"
            retval << get_row_display(b.board_state[0], 0)
            retval << div
            retval << get_row_display(b.board_state[1], 1)
            retval << div
            retval << get_row_display(b.board_state[2], 2)
            o_stream.puts retval
        end
    end
    class Reader
        def self.read_first_letter(i_stream = $stdin)
            i_stream.gets.chomp.downcase[0]
        end
    end
end
