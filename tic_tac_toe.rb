require "./board"
require "./player"
require "./aiplayer"
class TicTacToe
    def initialize
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
        puts "Goodbye!"
    end
end
def get_first
    first = nil
    until ["y", "n"].include? first
        puts "Would you like to go first (y/n)?"
        first = gets.chomp.downcase[0]
    end
    return first
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
def play_a_single_game(b, p)
    # Begin loop for a single game
    # Continues until there is a winner or a tie 
    turn = 0
    while b.winner == :none
        if p[turn%2].is_a? AIPlayer
            puts "AIPlayer's turn"
       end
        puts display_board(b)
        # If the player is a human, prompts for response
        # If the player is AI, selects best move
        r, c = p[turn%2].get_move(b)
        b.make_move(r, c)
        turn += 1
        puts "\n\n"
    end #end single game loop
    return b
end
def display_game_results(b, p)
    puts display_board(b)
    champ = b.winner
    if champ == :tie
        puts "It was a tie."
    elsif p[0].is_a?(Player) && champ == :X || 
          p[1].is_a?(Player) && champ == :O
        puts "You won!!!"
    else 
        puts "You lost!"
    end    
end
def play_again
    play = nil
    until ["y", "n"].include? play
        puts "Would you like to play again?(y or n)"
        play = gets.chomp.downcase[0]
    end
    return play
end
