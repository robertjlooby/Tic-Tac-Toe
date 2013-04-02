require "./move"
require "test/unit"

class MoveTests < Test::Unit::TestCase
    def test_move_equality
        assert_equal(Move.new(0, 0, 1, 2), Move.new(0, 0, 1, 2))
        assert_not_equal(Move.new(0, 0, 1, 2), Move.new(0, 0, 2, 2))
        assert_not_equal(Move.new(0, 0, 1, 2), Move.new(0, 0, 1, 0))
        assert_not_equal(Move.new(0, 0, 1, 2), Move.new(0, 1, 1, 2))
        assert_not_equal(Move.new(0, 0, 1, 2), Move.new(1, 0, 1, 2))
    end
end
