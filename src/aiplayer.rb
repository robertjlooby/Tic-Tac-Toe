require_relative './board'
require_relative './move'

class AIPlayer
    attr_reader :sym, :best_move
    def initialize(s)
        @sym = s
        # @best move is a hash of {board_state => Move}
        # The purpose of the hash is to memoize the best move for a given
        # board state, so that once it has been analyzed once it can then
        # just be looked up.
        @best_move = Hash.new
    end
    # The process the AI uses to pick a move is 
    # 1) If this board state has already been computed before, use the stored Move
    # 2) If a single move will end the game, that move will be made
    #    a) If there is a move that will result in a win, the AI will make that move
    #       and have an outcome of 2 if it is their turn, or assume the other player
    #       will make that move and have an outcome of 0 if it is the opponent's turn
    #    b) If there is only one open cell and going there does not result in a win,
    #       the AI will move there resulting in a tie
    # 3) If no single move will end the game, the AI will recursively call get_move
    #    on each board state resulting from all the available moves.  It will take
    #    all the moves that are returned and:
    #    a) If it is its own turn, will pick the move that leads to the highest outcome
    #    b) If it is the opponents turn, will pick the move that leads to the lowest
    #       outcome (i.e. it assumes perfect play by the opponent as well)
    def get_move(board, logic)
        if @best_move[board.board_state].nil?
            # Have not examined this board_state yet
            return get_game_ending_move(board, logic) unless get_game_ending_move(board, logic).nil?
            # Game will not be ended this turn, look for outcomes from all possible moves
            return get_next_move(board, logic)
        else
            # Have already examined this state, make the stored move
            return @best_move[board.board_state].fields
        end
    end
    def get_game_ending_move(board, logic)
        board.each_nil_cell do |row, col|
            new_board = board.deep_copy
            new_board.make_move(row, col)
            # If this move results in the game ending, store it and return it
            if logic.winner(new_board) != :none 
                @best_move[board.board_state] =  
                    if logic.winner(new_board) == @sym
                        Move.new(row, col, board.current_player, 2)
                    elsif logic.winner(new_board) == :tie
                        Move.new(row, col, board.current_player, 1)
                    else
                        Move.new(row, col, board.current_player, 0)
                    end
                return @best_move[board.board_state].fields
            end
        end
        return nil
    end
    def get_next_move(board, logic)
        moves = Array.new
        board.each_nil_cell do |row, col|
            new_board = board.deep_copy
            new_board.make_move(row, col)
            nr, nc, np, no = self.get_move(new_board, logic)
            # Collect array of all possible moves
            moves.push(Move.new(row, col, board.current_player, no))
        end
        move_sort(moves, board.current_player == @sym)
        @best_move[board.board_state] = moves[0]
        return moves[0].fields
    end
    def move_sort(moves, maximize)
        if maximize
            moves.sort! {|a, b| a <=> b}
        else
            moves.sort! {|a, b| b <=> a}
        end
    end
end
