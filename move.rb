class Move
    attr_reader :row
    attr_reader :col
    attr_reader :player
    attr_accessor :outcome
    def initialize(row, col, player, outcome = nil)
        unless (0..2).include? row
            raise "Invalid row #{row}. Should be 0, 1, or 2."
        end
        unless (0..2).include? col
            raise "Invalid col #{col}. Should be 0, 1, or 2."
        end
        unless (1..2).include? player
            raise "Invalid player #{player}. Should be 1 or 2."
        end
        unless outcome.nil? || (0..2).include?(outcome) 
            raise "Invalid outcome #{outcome}. Should be 0, 1, or 2."
        end
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
