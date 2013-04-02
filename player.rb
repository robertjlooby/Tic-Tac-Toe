require "./move"
require "./board"
class Player
    attr_reader :num
    attr_reader :best_move
    def initialize(n)
        unless (1..2).include? n
            raise "Player number must be a 1 or a 2"
        end
        # @num holds whether the player is playing first or second
        @num = n
        # @best move is a hash of {board_state => Move}
        # The board_state keys are the base 10 integer representation of 
        # the board state (so lookup will be fast).
        # The purpose of the hash it to memoize the best move for a given
        # board state, so that once it has been analyzed once it can then
        # just be looked up.
        @best_move = Hash.new
    end
    
    # Prompts the player for their move for a given board state and returns the 
    # move the player selects.
    # Will only accept moves for open board positions.
    def get_move(brd)
        unless brd.is_a? Board
            raise "Player#get_move takes a Board object."
        end
        r = nil
        c = nil
        # Prompt user for the row/column until they enter a valid cell, where valid means
        # both are 0, 1, or 2 and that cell is still open
        until (0..2).include?(r) && (0..2).include?(c) && brd.get_state_str[3*r + c] == "0"
            unless r.nil? && c.nil?
                puts "The row/column you entered was not valid!"
            end
            puts "Where would you like to move? (you are #{self.num == 1 ? "X" : "O"}'s, enter the row and column like \"1 1\")"
            r, c = gets.chomp.split
            if ["0", "1", "2"].include?(r) && ["0", "1", "2"].include?(c)
                r = r.to_i
                c = c.to_i
            end
        end
        return Move.new(r, c, self.num)
    end
            
end

# The AIPlayer class overrides Player#get_move to use the AI decision making process
class AIPlayer < Player

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
        unless brd.is_a? Board
            raise "AIPlayer#get_move takes a Board object."
        end
        if @best_move[brd.board_state].nil?
            # Have not examined this board_state yet
            0.upto(8) do |box|
                # Try each possible next move on the board to see
                # if it will finish the game
                if brd.get_state_str[box] == "0"
                    move = Move.new(box/3, box%3, brd.current_player)
                    new_brd = Board.new(brd.board_state, brd.current_player)
                    new_brd.make_move(move)
                    # If this move results in a win, store it and return it
                    if new_brd.winner != 0 
                        if new_brd.winner == self.num
                            move.outcome = 2
                        else
                            move.outcome = 0
                        end
                        @best_move[brd.board_state] = move
                        return move
                    elsif new_brd.tie?
                        # Board only had one open spot and game 
                        # ends in a tie
                        move.outcome = 1
                        @best_move[brd.board_state] = move
                        return move
                    end
                end
            end
            # Game will not be ended this turn, look for outcomes from all possible moves
            moves = Array.new
            0.upto(8) do |box|
                if brd.get_state_str[box] == "0"
                    move = Move.new(box/3, box%3, brd.current_player)
                    new_brd = Board.new(brd.board_state, brd.current_player)
                    new_brd.make_move(move)
                    next_move = self.get_move(new_brd)
                    move.outcome = next_move.outcome
                    # Collect array of all possible moves
                    moves.push(move)
                end
            end
            # Sort array of moves by their outcomes
            if brd.current_player == self.num
                # The current player wants to maximize the outcome
                moves.sort! {|a, b| a <=> b}
            else
                # Other players want to minimize the outcome for the current player
                # (i.e. by maximizing their own outcome)
                moves.sort! {|a, b| b <=> a}
            end
            @best_move[brd.board_state] = moves[0]
            return @best_move[brd.board_state]
        else
            # Have already examined this state, make the stored move
            return @best_move[brd.board_state]
        end
    end
end
