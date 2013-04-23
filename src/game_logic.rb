class GameLogic
    # Checks the board to see if there is a winner.  Will return :X or :O
    # if that player has won, :tie if it is a tie, and :none otherwise
    def self.winner(board)
        # Check if any of the rows or columns are a win
        (0..2).each do |n|
            return board.board_state[n][n] if three_in_a_row?(board.row(n)) or 
                                              three_in_a_row?(board.col(n))
        end
        # Check diagonals
        return board.board_state[1][1] if three_in_a_row?(board.diag(:left)) or 
                                          three_in_a_row?(board.diag(:right))
        return :tie unless board.board_state.flatten.include? nil
        return :none
    end

    # Checks that all elements of the array passed to it are non-nil and are the same
    def self.three_in_a_row?(arr)
        return false if arr[0].nil?
        return arr.count(arr[0]) == arr.size
    end
end
