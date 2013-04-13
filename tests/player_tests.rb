require 'test/unit'
require 'stringio'
require_relative '../src/player'
require_relative '../src/board'

class PlayerTests < Test::Unit::TestCase
    def setup
        @reader = MockReader.new
        @writer = MockWriter.new
        @p1 = Player.new(:X)
        @p2 = Player.new(:O)
    end
    def test_player_initialization
        assert_equal(:X, @p1.sym)
        assert_equal(:O, @p2.sym)
    end
    def test_player_get_move_good_move
        b = Board.new
        @reader.responses = ["0"]

        r, c = @p1.get_move(b.board_state, @reader, @writer)
        assert_equal(r, 0)
        assert_equal(c, 0)
        assert_equal(1, @reader.times_read)
        assert_equal(1, @writer.times_asked_for_cell)
        assert_equal(0, @writer.times_notified_invalid_cell)
    end
    def test_player_get_move_move_with_bad_input
        b = Board.new
        @reader.responses = ["junk", "1still junk", "7"]

        r, c = @p1.get_move(b.board_state, @reader, @writer)
        assert_equal(r, 2)
        assert_equal(c, 1)
        assert_equal(3, @reader.times_read)
        assert_equal(3, @writer.times_asked_for_cell)
        assert_equal(2, @writer.times_notified_invalid_cell)
    end
    def test_player_get_move_move_with_taken_cells
        b = Board.new([[:X, :X, :O], [:X, :O, nil], [nil, :O, nil]], :X)
        @reader.responses = ["0", "1", "2", "7", "8"]

        r, c = @p1.get_move(b.board_state, @reader, @writer)
        assert_equal(r, 2)
        assert_equal(c, 2)
        assert_equal(5, @reader.times_read)
        assert_equal(5, @writer.times_asked_for_cell)
        assert_equal(4, @writer.times_notified_invalid_cell)
    end
    
    class MockWriter
        attr_accessor :times_asked_for_cell, :times_notified_invalid_cell
        def initialize
            @times_asked_for_cell = @times_notified_invalid_cell = 0
        end
        def ask_for_cell(sym)
            @times_asked_for_cell += 1
        end
        def notify_invalid_cell
            @times_notified_invalid_cell += 1
        end
    end
    class MockReader
        attr_accessor :times_read, :responses
        def initialize
            @times_read = 0
        end
        def read_cell
            @times_read += 1
            @responses.shift
        end
    end
end
