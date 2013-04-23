class Board
    attr_reader :board_state, :current_player
    def initialize(board_state = Array.new(3){ Array.new(3, nil) }, player = :X)
        @board_state = board_state
        @current_player = player
    end

    # Given a row and column, makes the move which alters @board_state
    def make_move(row, col)
        @board_state[row][col] = @current_player
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
    def deep_copy
        Board.new(Array.new(3){|row| Array.new(@board_state[row])}, @current_player)
    end
    def each_cell
        (0..2).each do |row|
            (0..2).each do |col|
                yield(row, col)
            end
        end
    end
end
