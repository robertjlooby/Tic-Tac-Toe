require 'test/unit'
require_relative '../src/board'

class BoardTests < Test::Unit::TestCase
    def test_board_initialization
        b = Board.new
        arr = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        assert_equal(arr, b.board_state, "Initial board state should be all nils")
        assert_equal(:X, b.current_player, "Initial player should be :X")

        b = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        arr = [[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]]
        assert_equal(arr, b.board_state, "Board initialize should set board_state")
        assert_equal(:O, b.current_player, "Board initialize should set current_player")
    end
    def test_make_moves
        b = Board.new

        assert_equal([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]], b.board_state)
        assert_equal(:X, b.current_player)

        b.make_move(0, 0)
        assert_equal([[:X, nil, nil], [nil, nil, nil], [nil, nil, nil]], b.board_state)
        assert_equal(:O, b.current_player)

        b.make_move(1, 1)
        assert_equal([[:X, nil, nil], [nil, :O, nil], [nil, nil, nil]], b.board_state)
        assert_equal(:X, b.current_player)

        b.make_move(0, 2)
        assert_equal([[:X, nil, :X], [nil, :O, nil], [nil, nil, nil]], b.board_state)
        assert_equal(:O, b.current_player)

        b.make_move(0, 1)
        assert_equal([[:X, :O, :X], [nil, :O, nil], [nil, nil, nil]], b.board_state)
        assert_equal(:X, b.current_player)
    end
end
