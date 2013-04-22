require 'test/unit'
require_relative '../src/move'

class AIPlayerTests < Test::Unit::TestCase
    def test_initialization
        m = Move.new(1, 2, :X, 0)
        assert_equal(1, m.row)
        assert_equal(2, m.col)
        assert_equal(:X, m.player)
        assert_equal(0, m.outcome)
    end
    def test_equality
        m1 = Move.new(1, 2, :X, 0)
        m2 = Move.new(1, 2, :X, 0)
        m3 = Move.new(0, 2, :X, 0)
        m4 = Move.new(1, 0, :X, 0)
        m5 = Move.new(1, 2, :O, 0)
        m6 = Move.new(1, 2, :X, 1)
        assert_equal(m1, m2)
        assert_not_equal(m1, m3)
        assert_not_equal(m1, m4)
        assert_not_equal(m1, m5)
        assert_not_equal(m1, m6)
    end
    def test_compare
        m1 = Move.new(0, 0, :X, 0)
        m2 = Move.new(0, 0, :X, 1)
        m3 = Move.new(0, 0, :X, 2)
        m4 = Move.new(1, 1, :X, 0)
        m5 = Move.new(1, 1, :X, 1)
        m6 = Move.new(1, 1, :X, 2)
        moves = [m1, m2, m3, m4, m5, m6]
        moves.sort!
        assert_equal([m6, m3, m5, m2, m4, m1], moves)
    end
    def test_fields
        m = Move.new(1, 2, :X, 0)
        assert_equal([1, 2, :X, 0], m.fields)
    end
end
