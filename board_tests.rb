# encoding: UTF-8
require "test/unit"
require "./board"

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
    def test_winner
        b = Board.new
        assert_equal(:none, b.winner)

        b = Board.new([[:X, :O, :X], [nil, :O, nil], [nil, :X, nil]], :O)
        assert_equal(:none, b.winner)

        b = Board.new([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], :O)
        assert_equal(:tie, b.winner)

        b = Board.new([[:O, :X, :X], [:X, :X, :O], [:O, :O, :X]], :O)
        assert_equal(:tie, b.winner)

        b = Board.new([[:X, :O, :O], [:X, :X, :O], [:O, :X, :X]], :O)
        assert_equal(:X, b.winner)

        b = Board.new([[:X, :X, :O], [:X, :O, nil], [:O, nil, nil]], :X)
        assert_equal(:O, b.winner)
    end
    def test_three_in_a_row
        assert_equal(false, three_in_a_row?(nil,nil,nil))
        assert_equal(false, three_in_a_row?(nil,:X,:X))
        assert_equal(false, three_in_a_row?(:X,:X,nil))
        assert_equal(false, three_in_a_row?(:X,:X,:O))
        assert_equal(true, three_in_a_row?(:X,:X,:X))
        assert_equal(true, three_in_a_row?(:O,:O,:O))
    end
    def test_display_board
        b = Board.new
        assert_equal("   ┃   ┃   \n" + 
                     "   ┃   ┃   \n" + 
                     "  0┃  1┃  2\n" + 
                     "━━━╋━━━╋━━━\n" + 
                     "   ┃   ┃   \n" + 
                     "   ┃   ┃   \n" + 
                     "  3┃  4┃  5\n" + 
                     "━━━╋━━━╋━━━\n" + 
                     "   ┃   ┃   \n" + 
                     "   ┃   ┃   \n" + 
                     "  6┃  7┃  8\n", display_board(b))
        
        b = Board.new([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], :O)
        assert_equal("╲ ╱┃┌─┐┃╲ ╱\n" + 
                     " ╳ ┃│ │┃ ╳ \n" + 
                     "╱ ╲┃└─┘┃╱ ╲\n" + 
                     "━━━╋━━━╋━━━\n" + 
                     "┌─┐┃┌─┐┃╲ ╱\n" + 
                     "│ │┃│ │┃ ╳ \n" + 
                     "└─┘┃└─┘┃╱ ╲\n" + 
                     "━━━╋━━━╋━━━\n" + 
                     "╲ ╱┃╲ ╱┃┌─┐\n" + 
                     " ╳ ┃ ╳ ┃│ │\n" + 
                     "╱ ╲┃╱ ╲┃└─┘\n", display_board(b))
    end
end
