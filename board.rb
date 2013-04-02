require "./move"
class Board
    attr_reader :board_state
    attr_reader :current_player
    def initialize(n = 0, p = 1)
        # The state of the 3x3 game board is represented internally as a
        # base 10 integer @board_state. When converted to a 9 digit
        # base 3 integer, each digit corresponds to a cell on the board
        # in a left to right, top to bottom fashion.   
        # A 0 is an empty cell
        # A 1 is a cell with an 'X'
        # A 2 is a cell with an 'O'
        @board_state = n
        @current_player = p
    end

    # Returns a string display of the board, including row and column
    # numbers to make selecting moves easier for the user
    def display
        retval = ""
        div = " | -+-+-\n"
        state_str = self.get_state_str
        retval << "   0 1 2\n" # Column numbers
        retval << "   -----\n"
        retval << "0| " + get_row_display(state_str[0..2])
        retval << div
        retval << "1| " + get_row_display(state_str[3..5])
        retval << div
        retval << "2| " + get_row_display(state_str[6..8])
    end


    # Takes a string of three base 3 numbers and returns that row
    # to be displayed on the board
    def get_row_display(row_str)
        row_display = ""
        row_display << get_sym(row_str[0]) + "|"
        row_display << get_sym(row_str[1]) + "|"
        row_display << get_sym(row_str[2]) + "\n"
    end

    # Takes a single base 3 number and returns the correct
    # symbol for that cell " ", "X", or "O"
    def get_sym(n)
        case n
        when "0"
            " "
        when "1"
            "X"
        when "2"
            "O"
        else
            raise "Invalid board element #{n}. Should be 0, 1, or 2."
        end
    end

    # Converts the internally stored @board_state and converts it to a
    # 9 digit string representation in base 3 of the board
    def get_state_str
        # First convert the base 10 integer to a base 3 string representation
        state_str = @board_state.to_s(3)
        if state_str.size > 9
            raise "Board is in an impossible state"
        end
        # Then pad with 0s to the front until it is 9 digits long
        while state_str.size < 9 do
            state_str = "0" + state_str
        end
        state_str
    end

    # Given a Move object, makes the move which alters @board_state
    def make_move(move)
        unless move.is_a? Move
            raise "Board#make_move must be given a Move object"
        end
        unless move.player == @current_player
            raise "It is not player #{move.player}'s turn."
        end
        # Find the box the move is in from 8 at the top left corner
        # to 0 in the bottom right corner
        box_no = 8 - 3*move.row - move.col
        # Find the base 10 value that should be added to @board_state
        move_val = (3**box_no)*move.player
        if current_player == 1
            @current_player = 2
        else 
            @current_player = 1
        end
        @board_state += move_val
    end

    # Checks the board to see if there is a winner.  Will return 1 or 2 if
    # player 1 or 2 has won.  Otherwise returns 0.
    def winner
        state_str = self.get_state_str
        # Check if any of the rows are a win
        0.upto(2) do |r|
            if three_in_a_row?(state_str[3*r].to_i, state_str[3*r+1].to_i, state_str[3*r+2].to_i)
                return state_str[3*r].to_i
            end
        end
        # Check if any of the columns are a win
        0.upto(2) do |c|
            if three_in_a_row?(state_str[c].to_i, state_str[3+c].to_i, state_str[6+c].to_i)
                return state_str[c].to_i
            end
        end
        # Check diagonals
        if three_in_a_row?(state_str[0].to_i, state_str[4].to_i, state_str[8].to_i)
            return state_str[0].to_i
        end
        if three_in_a_row?(state_str[2].to_i, state_str[4].to_i, state_str[6].to_i)
            return state_str[2].to_i
        end
        # No winner found
        return 0
    end
        
    # Checks if the game has resulted in a tie
    def tie?
        return !(self.get_state_str.include? "0" || self.winner != 0)
    end

    # Checks that all three numbers passed to it are non-zero and are the same
    def three_in_a_row?(a, b, c)
        return a != 0 && a == b && b == c
    end
end
