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
        return -1 if @outcome > other.outcome
        return  1 if @outcome < other.outcome
        return -1 if @row == 1 && @col == 1
        return  1 if other.row == 1 && other.col == 1
        return  0
    end
    def fields
        return @row, @col, @player, @outcome
    end
    def to_s
        "Move: row=#{@row}, col=#{@col}, player=#{@player}, outcome=#{@outcome}"
    end
end
