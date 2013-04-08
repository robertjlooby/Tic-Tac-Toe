require "test/unit"
require "./tic_tac_toe"

# requires input piped from tic_tac_toe_tests.txt
class PlayerTests < Test::Unit::TestCase
    def test_get_first
        assert_equal("y", get_first)
        assert_equal("n", get_first)
    end
    def test_set_up_game
        b, p = set_up_game("y")
        assert(b.is_a? Board)
        assert(p[0].is_a? Player)
        assert(p[1].is_a? AIPlayer)
        assert_equal(:X, p[0].sym)
        assert_equal(:O, p[1].sym)

        b, p = set_up_game("n")
        assert(b.is_a? Board)
        assert(p[0].is_a? AIPlayer)
        assert(p[1].is_a? Player)
        assert_equal(:X, p[0].sym)
        assert_equal(:O, p[1].sym)
    end
    def test_play_a_single_game
        b, p = set_up_game("y")
        b = play_a_single_game(b, p)
        assert_equal(:tie, b.winner)
        assert_equal([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], b.board_state)
    end
    def test_play_again
        assert_equal("y", play_again)
        assert_equal("n", play_again)
    end
end
