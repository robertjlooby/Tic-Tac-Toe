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
    def get_move(brd, logic)
        if @best_move[brd.board_state].nil?
            # Have not examined this board_state yet
            r, c, p, o = get_game_ending_move(brd, logic)
            return r, c, p, o unless r.nil?
            # Game will not be ended this turn, look for outcomes from all possible moves
            return get_next_move(brd, logic)
        else
            # Have already examined this state, make the stored move
            move = @best_move[brd.board_state]
            return move.row, move.col, move.player, move.outcome
        end
    end
    def get_game_ending_move(brd, logic)
        (0..2).each do |r|
            (0..2).each do |c|
                # Try each possible next move on the board to see
                # if it will finish the game
                if brd.board_state[r][c].nil?
                    new_brd = brd.deep_copy
                    new_brd.make_move(r, c)
                    # If this move results in a win, store it and return it
                    if logic.winner(new_brd) != :none 
                        move =  if logic.winner(new_brd) == @sym
                                    Move.new(r, c, brd.current_player, 2)
                                elsif logic.winner(new_brd) == :tie
                                    Move.new(r, c, brd.current_player, 1)
                                else
                                    Move.new(r, c, brd.current_player, 0)
                        end
                        @best_move[brd.board_state] = move
                        return move.row, move.col, move.player, move.outcome
                    end
                end
            end
        end
        return nil
    end
    def get_next_move(brd, logic)
        moves = Array.new
        (0..2).each do |r|
            (0..2).each do |c|
                if brd.board_state[r][c].nil?
                    new_brd = brd.deep_copy
                    new_brd.make_move(r, c)
                    nr, nc, np, no = self.get_move(new_brd, logic)
                    # Collect array of all possible moves
                    moves.push(Move.new(r, c, brd.current_player, no))
                end
            end
        end
        # Sort array of moves by their outcomes
        if brd.current_player == @sym
            # The current player wants to maximize the outcome
            moves.sort! {|a, b| a <=> b}
        else
            # Other players want to minimize the outcome for the current player
            # (i.e. by maximizing their own outcome)
            moves.sort! {|a, b| b <=> a}
        end
        @best_move[brd.board_state] = moves[0]
        return moves[0].row, moves[0].col, moves[0].player, moves[0].outcome
    end
end
