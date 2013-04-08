require "./board"
class Player
    attr_reader :sym
    def initialize(n)
        # holds whether the player's symbol(:X or :O)
        @sym = n
    end
    
    # Prompts the player for their move for a given board state and returns the 
    # move the player selects.
    # Will only accept moves for open board positions.
    def get_move(brd)
        r = c = cell = nil
        # Prompt user for the row/column until they enter a valid cell, where valid means
        # both are 0, 1, or 2 and that cell is still open
        until r != nil && c != nil && brd.board_state[r][c].nil?
            unless cell == nil
                puts "The cell you entered was not valid!"
            end
            puts "Where would you like to move? (you are #{@sym.to_s}'s, enter the cell number)"
            cell = gets.chomp.strip
            if ("0".."8").include?(cell)
                r = cell.to_i/3
                c = cell.to_i%3
            end
        end
        return r, c
    end
end
