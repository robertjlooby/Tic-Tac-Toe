require 'test/unit'
require_relative '../src/board'
require_relative '../src/game_logic'

class GameLogicTests < Test::Unit::TestCase
    def test_three_in_a_row
        assert_equal(false, GameLogic.three_in_a_row?([nil,nil,nil]))
        assert_equal(false, GameLogic.three_in_a_row?([nil,:X,:X]))
        assert_equal(false, GameLogic.three_in_a_row?([:X,:X,nil]))
        assert_equal(false, GameLogic.three_in_a_row?([:X,:X,:O]))
        assert_equal(true, GameLogic.three_in_a_row?([:X,:X,:X]))
        assert_equal(true, GameLogic.three_in_a_row?([:O,:O,:O]))
    end
    def test_winner
        b = Board.new
        assert_equal(:none, GameLogic.winner(b))

        b = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        assert_equal(:none, GameLogic.winner(b))

        b = Board.new([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], :O)
        assert_equal(:tie, GameLogic.winner(b))

        b = Board.new([[:O, :X, :X], [:X, :X, :O], [:O, :O, :X]], :O)
        assert_equal(:tie, GameLogic.winner(b))

        b = Board.new([[:X, :O, :O], [:X, :X, :O], [:O, :X, :X]], :O)
        assert_equal(:X, GameLogic.winner(b))

        b = Board.new([[:X, :X, :O], [:X, :O, nil], [:O, nil, nil]], :X)
        assert_equal(:O, GameLogic.winner(b))
    end
end
