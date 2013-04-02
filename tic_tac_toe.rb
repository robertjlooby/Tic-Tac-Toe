require "./board"
require "./player"
require "./move"
class TicTacToe
    turn = -1
    play = "y"
    # Begin game loop, will play games as long as the user wants to
    while play == "y"
        # Loop until the user enters a valid choice of playing
        # first or second
        until (1..2).include? turn
            puts "Would you like to go first or second?(1 or 2)"
            turn = gets.chomp.to_i
        end

        # Initialize the board and players
        b = Board.new
        players = Array.new
        if turn == 1
            # user chose to play first
            players.push(Player.new(1))
            players.push(AIPlayer.new(2))
        else
            # user chose to play second
            players.push(AIPlayer.new(1))
            players.push(Player.new(2))
        end

        # Begin loop for a single game
        # Continues until there is a winner or a tie 
        while b.winner == 0 && !b.tie?
            if players[b.current_player-1].is_a? AIPlayer
                puts "AIPlayer's turn"
            end
            puts b.display
            # If the player is a human, prompts for response
            # If the player is AI, selects best move
            m = players[b.current_player-1].get_move(b)
            b.make_move(m)
            puts "\n\n"
        end #end single game loop

        # Determine and display the game results
        champ = b.winner
        puts b.display
        if turn == champ
            puts "You won!!!"
        elsif champ == 0
            puts "It was a tie."
        else
            puts "You lost!"
        end    
        
        # Let player choose if they want to play another game
        play = "d"
        turn = -1
        until ["y", "n"].include? play
            puts "Would you like to play again?(y or n)"
            play = gets.chomp.downcase[0]
        end
    end
    puts "Goodbye!"
end
