class Board
    attr_reader :board_state, :current_player
    def initialize(n = Array.new(3){ Array.new(3, nil) }, p = :X)
        @board_state = n
        @current_player = p
    end

    # Given a row and column, makes the move which alters @board_state
    def make_move(r, c)
        @board_state[r][c] = @current_player
        @current_player = (@current_player == :X ? :O : :X)
    end

    def row(n)
        @board_state[n]
    end
    def col(n)
        [@board_state[0][n], @board_state[1][n], @board_state[2][n]]
    end
    def diag(direction)
        if direction == :right
            return [@board_state[0][0], @board_state[1][1], @board_state[2][2]]
        else
            return [@board_state[0][2], @board_state[1][1], @board_state[2][0]]
        end
    end

    # Checks the board to see if there is a winner.  Will return :X or :O
    # if that player has won, :tie if it is a tie, and :none otherwise
    def winner
        # Check if any of the rows or columns are a win
        0.upto(2) do |n|
            if three_in_a_row?(row(n)) or three_in_a_row?(col(n))
                return @board_state[n][n]
            end
        end
        # Check diagonals
        if three_in_a_row?(diag(:left)) or three_in_a_row?(diag(:right))
            return @board_state[1][1]
        end
        unless @board_state.flatten.include? nil
            return :tie
        end
        return :none
    end
end

# Checks that all elements of the array passed to it are non-nil and are the same
def three_in_a_row?(a)
    return false if a[0].nil?
    1.upto(a.size - 1) do |n|
        return false unless a[0] == a[n]
    end
    return true
end
