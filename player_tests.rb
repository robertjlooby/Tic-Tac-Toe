require "test/unit"
require "./player"

class PlayerTests < Test::Unit::TestCase
    def test_makes_winning_move 
        brd = Board.new
        brd.make_move(Move.new(0, 0, 1))
        brd.make_move(Move.new(1, 2, 2))
        brd.make_move(Move.new(1, 1, 1))
        brd.make_move(Move.new(2, 1, 2))
        p = AIPlayer.new(1)
        m = p.get_move(brd)
        assert_equal(Move.new(2, 2, 1, 2), m, "AI should choose winning move")
    end
    def test_assumes_opponent_will_make_winning_move
        brd = Board.new(9423, 2)
        p = AIPlayer.new(2)
        m = p.get_move(brd)
        assert_equal(Move.new(0, 2, 1, 0), p.best_move[9441], "AI should assume other player will choose winning move")
        assert_equal(Move.new(0, 2, 2, 1), m, "AI should make move to force a tie")
    end
end
