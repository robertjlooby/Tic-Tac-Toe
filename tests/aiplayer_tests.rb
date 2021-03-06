require 'test/unit'
require_relative '../src/aiplayer'
require_relative '../src/game_logic'

class AIPlayerTests < Test::Unit::TestCase
    def test_aiplayer_initialization
        p = AIPlayer.new(:X)
        assert_equal(:X, p.sym, "AIPlayer#sym should be :X")
        assert_equal({}, p.best_move, "AIPlayer#best_move should be {} initially")
        p2 = AIPlayer.new(:O)
        assert_equal(:O, p2.sym)
    end
    def test_makes_winning_move 
        brd = Board.new([[:X, nil, nil], [nil, :X, :O], [:O, nil, nil]], :X)
        pl = AIPlayer.new(:X)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(2, 2, :X, 2), Move.new(r, c, p, o), "AI should choose winning move")

        brd = Board.new([[:X, :O, nil], [nil, :O, nil], [:X, nil, nil]], :X)
        pl = AIPlayer.new(:X)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(1, 0, :X, 2), Move.new(r, c, p, o), "AI should choose winning move")

        brd = Board.new([[:X, :O, nil], [nil, :O, nil], [:X, nil, :X]], :O)
        pl = AIPlayer.new(:O)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(2, 1, :O, 2), Move.new(r, c, p, o), "AI should choose winning move")
    end
    def test_player_makes_tying_move
        brd = Board.new([[:X, :X, :O],
                         [:O, :O, :X],
                         [:X, :O, nil]], :X)
        pl = AIPlayer.new(:X)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(2, 2, :X, 1), Move.new(r, c, p, o), "AI should choose tying move")

        brd = Board.new([[:X, :O, :X],
                         [:X, nil, :O],
                         [:O, :X, :O]], :X)
        pl = AIPlayer.new(:X)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(1, 1, :X, 1), Move.new(r, c, p, o), "AI should choose tying move")
    end
    def test_assumes_opponent_will_make_winning_move
        brd = Board.new([[:X, :X, nil], 
                         [:O, :O, :X], 
                         [nil, nil, nil]], :O)
        pl = AIPlayer.new(:O)
        r, c, p, o = pl.get_move(brd, GameLogic)
        assert_equal(Move.new(0, 2, :X, 0), pl.best_move[[[:X, :X, nil], [:O, :O, :X], [:O, nil, nil]]], "AI should assume other player will choose winning move")
        assert_equal(Move.new(0, 2, :O, 1), Move.new(r, c, p, o), "AI should make move to force a tie")
    end
    def test_move_sort
        pl = AIPlayer.new(:X)
        m1 = Move.new(0, 0, :X, 0)
        m2 = Move.new(0, 0, :X, 1)
        m3 = Move.new(0, 0, :X, 2)
        m4 = Move.new(1, 1, :X, 0)
        m5 = Move.new(1, 1, :X, 1)
        m6 = Move.new(1, 1, :X, 2)
        moves = [m1, m2, m3, m4, m5, m6]
        pl.move_sort(moves, true)
        assert_equal([m6, m3, m5, m2, m4, m1], moves)
        pl.move_sort(moves, false)
        assert_equal([m1, m4, m2, m5, m3, m6], moves)
    end
end
