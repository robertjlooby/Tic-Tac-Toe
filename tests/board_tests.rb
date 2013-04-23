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
    def test_row
        b = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        assert_equal([:X, :O, :X], b.row(0))
        assert_equal([nil, :O, nil], b.row(1))
        assert_equal([nil, :X, nil], b.row(2))
    end
    def test_col
        b = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        assert_equal([:X, nil, nil], b.col(0))
        assert_equal([:O, :O, :X], b.col(1))
        assert_equal([:X, nil, nil], b.col(2))
    end
    def test_diag
        b = Board.new([[:X, :O, :O], [nil, :O, nil], [nil, :X, nil]], :O)
        assert_equal([:X, :O, nil], b.diag(:right))
        assert_equal([:O, :O, nil], b.diag(:left))
    end
    def test_deep_copy
        b1 = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        b2 = b1.deep_copy
        assert_equal(b1.board_state, b2.board_state)
        assert_equal(b1.current_player, b2.current_player)
        assert_not_equal(b1.object_id, b2.object_id)
        assert_not_equal(b1.board_state.object_id, b2.board_state.object_id)
    end
    def test_each_cell
        b = Board.new
        calls = 0
        b.each_cell do |row, col|
            assert_equal(calls / 3, row)
            assert_equal(calls % 3, col)
            calls += 1
        end
    end
end
