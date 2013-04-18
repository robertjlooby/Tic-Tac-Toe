require_relative './board'

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
    def get_move(brd)
        if @best_move[brd.board_state].nil?
            # Have not examined this board_state yet
            (0..2).each do |r|
                (0..2).each do |c|
                    # Try each possible next move on the board to see
                    # if it will finish the game
                    if brd.board_state[r][c].nil?
                        new_brd = Board.new(Array.new(3){|r| Array.new(brd.board_state[r])}, brd.current_player)
                        new_brd.make_move(r, c)
                        # If this move results in a win, store it and return it
                        if new_brd.winner != :none 
                            move =  if new_brd.winner == @sym
                                        Move.new(r, c, brd.current_player, 2)
                                    elsif new_brd.winner == :tie
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
            # Game will not be ended this turn, look for outcomes from all possible moves
            moves = Array.new
            (0..2).each do |r|
                (0..2).each do |c|
                    if brd.board_state[r][c].nil?
                        new_brd = Board.new(Array.new(3){|r| Array.new(brd.board_state[r])}, brd.current_player)
                        new_brd.make_move(r, c)
                        nr, nc, np, no = self.get_move(new_brd)
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
        else
            # Have already examined this state, make the stored move
            move = @best_move[brd.board_state]
            return move.row, move.col, move.player, move.outcome
        end
    end
    class Move
        attr_reader :row, :col, :player, :outcome
        def initialize(row, col, player, outcome)
            @row = row
            @col = col
            @player = player
            # The outcome is defined as a 0 if this move will eventually 
            # result in a loss, 1 if it eventually results in a tie, or 
            # 2 if it eventually results in a win
            @outcome = outcome
        end

        # Two moves are considered equal if all their internal data are equal
        def ==(other)
            return other.is_a?(Move) && @row == other.row && @col == other.col && @player == other.player && @outcome == other.outcome
        end

        # For sorting Arrays of moves
        # The player wants to make moves that have the highest outcome
        # and if outcomes are tied will favor moves in the center as these give
        # the opponent more chances to mess up.
        def <=>(other)
            if @outcome > other.outcome
                return -1
            elsif @outcome < other.outcome
                return 1
            elsif @row == 1 && @col == 1
                return -1
            elsif other.row == 1 && other.col == 1
                return 1
            else
                return 0
            end
        end
        def to_s
            "Move: row=#{@row}, col=#{@col}, player=#{@player}, outcome=#{@outcome}"
        end
    end
end
