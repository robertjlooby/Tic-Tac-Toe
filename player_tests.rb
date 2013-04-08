require "test/unit"
require "./player"
require "./board"

# requires input piped from player_tests.txt
class PlayerTests < Test::Unit::TestCase
    def test_player_initialization
        p = Player.new(:X)
        assert_equal(:X, p.sym)

        p = Player.new(:O)
        assert_equal(:O, p.sym)
    end
    def test_player_get_move
        b = Board.new
        p = Player.new(:X)

        r, c = p.get_move(b)
        assert_equal(r, 0)
        assert_equal(c, 0)

        r, c = p.get_move(b)
        assert_equal(r, 2)
        assert_equal(c, 1)

        b = Board.new([[:X, :X, :O], [:X, :O, nil], [nil, :O, nil]], :X)
        r, c = p.get_move(b)
        assert_equal(r, 2)
        assert_equal(c, 2)
    end
end
