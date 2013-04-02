require "test/unit"
require "./board"

class BoardTests < Test::Unit::TestCase
    def test_display_empty_board 
        brd = Board.new
        emp_brd = "   0 1 2\n   -----\n0|  | | \n | -+-+-\n1|  | | \n | -+-+-\n2|  | | \n" 
        assert_equal(emp_brd, brd.display, "Empty board not correctly displayed")
    end
    def test_empty_state_str
        brd = Board.new
        assert_equal("000000000", brd.get_state_str, "state_str for empty board not correct")
    end
    def test_board_initializer
        brd = Board.new
        assert_equal(0, brd.board_state)
        assert_equal(1, brd.current_player)
        brd2 = Board.new(14884, 2)
        assert_equal(14884, brd2.board_state)
        assert_equal(2, brd2.current_player)
    end
    def test_make_moves
        brd = Board.new
        brd.make_move(Move.new(0, 0, 1))
        brd_disp = "   0 1 2\n   -----\n0| X| | \n | -+-+-\n1|  | | \n | -+-+-\n2|  | | \n"
        assert_equal(brd_disp, brd.display, "Board display not working after first move in top left corner")
        brd.make_move(Move.new(2, 2, 2))
        brd_disp = "   0 1 2\n   -----\n0| X| | \n | -+-+-\n1|  | | \n | -+-+-\n2|  | |O\n"
        assert_equal(brd_disp, brd.display, "Board display not working after first move in bottom right corner")
    end
    def test_get_state_str
        brd = Board.new
        brd.make_move(Move.new(2, 2, 1))
        assert_equal("000000001", brd.get_state_str)
        brd.make_move(Move.new(0, 0, 2))
        assert_equal("200000001", brd.get_state_str)
        brd.make_move(Move.new(0, 2, 1))
        assert_equal("201000001", brd.get_state_str)
    end
    def test_three_in_a_row
        brd = Board.new
        assert_equal(false, brd.three_in_a_row?(0,0,0))
        assert_equal(false, brd.three_in_a_row?(0,1,1))
        assert_equal(false, brd.three_in_a_row?(1,1,0))
        assert_equal(false, brd.three_in_a_row?(1,1,2))
        assert_equal(true, brd.three_in_a_row?(1,1,1))
        assert_equal(true, brd.three_in_a_row?(2,2,2))
    end
    def test_winner
        brd = Board.new
        assert_equal(0, brd.winner)
        brd.make_move(Move.new(0, 0, 1))
        assert_equal(0, brd.winner)
        brd.make_move(Move.new(1, 1, 2))
        assert_equal(0, brd.winner)
        brd.make_move(Move.new(1, 0, 1))
        assert_equal(0, brd.winner)
        brd.make_move(Move.new(2, 2, 2))
        assert_equal(0, brd.winner)
        brd.make_move(Move.new(2, 0, 1))
        assert_equal(1, brd.winner)
        brd_disp = "   0 1 2\n   -----\n0| X| | \n | -+-+-\n1| X|O| \n | -+-+-\n2| X| |O\n"
        assert_equal(brd_disp, brd.display)
    end
    def test_tie
        brd = Board.new(10895, 2)
        assert(brd.tie?)
    end
end
