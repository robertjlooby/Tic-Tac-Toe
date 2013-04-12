require 'test/unit'
require 'stringio'
require_relative '../src/tic_tac_toe'
require_relative '../tests/player_tests'

class TicTacToeTests < Test::Unit::TestCase
    def setup
        @reader = MockReader.new
        @writer = MockWriter.new
        @game = TicTacToe.new
    end
    def test_get_first_y
        @reader.responses = ["y"]
        assert_equal("y", @game.get_first(@reader, @writer))
        assert_equal(1, @reader.times_read)
        assert_equal(1, @writer.times_asked_for_first)
    end
    def test_get_first_with_bad_responses
        @reader.responses = ["bad input", "maybe", "n"]
        assert_equal("n", @game.get_first(@reader, @writer))
        assert_equal(3, @reader.times_read)
        assert_equal(3, @writer.times_asked_for_first)
    end
    def test_set_up_game
        b, p = @game.set_up_game("y")
        assert(b.is_a? Board)
        assert(p[0].is_a? Player)
        assert(p[1].is_a? AIPlayer)
        assert_equal(:X, p[0].sym)
        assert_equal(:O, p[1].sym)

        b, p = @game.set_up_game("n")
        assert(b.is_a? Board)
        assert(p[0].is_a? AIPlayer)
        assert(p[1].is_a? Player)
        assert_equal(:X, p[0].sym)
        assert_equal(:O, p[1].sym)
    end
    def test_play_a_single_game
        @player_reader = PlayerTests::MockReader.new
        @player_reader.responses = ["0", "2", "7", "5", "6"]
        @player_writer = PlayerTests::MockWriter.new
        b, p = @game.set_up_game("y")
        b = @game.play_a_single_game(b, p, @writer, @player_reader, @player_writer)
        assert_equal(:tie, b.winner)
        assert_equal([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], b.board_state)
        assert_equal(5, @player_reader.times_read)
        assert_equal(5, @player_writer.times_asked_for_cell)
        assert_equal(0, @player_writer.times_notified_invalid_cell)
        assert_equal(4, @writer.times_said_ai_turn)
        assert_equal(9, @writer.times_displayed_board)
        assert_equal(9, @writer.times_added_spacing)
    end
    def test_display_game_results
        b = Board.new([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], :O)
        p = Player.new(:X)
        @game.display_game_results(b, p, @writer)
        assert_equal(1, @writer.times_displayed_board)
        assert_equal(1, @writer.times_said_tie)
        assert_equal(0, @writer.times_said_lost)
        assert_equal(0, @writer.times_said_win)
    end
    def test_play_again_y
        @reader.responses = ["y"]
        assert_equal("y", @game.play_again(@reader, @writer))
        assert_equal(1, @writer.times_asked_for_play_again)
        assert_equal(1, @reader.times_read)
    end
    def test_play_again_with_bad_responses
        @reader.responses = ["of course!", "maybe", "n"]
        assert_equal("n", @game.play_again(@reader, @writer))
        assert_equal(3, @writer.times_asked_for_play_again)
        assert_equal(3, @reader.times_read)
    end
    class MockWriter
        attr_accessor :times_asked_for_first,
                      :times_asked_for_play_again,
                      :times_said_ai_turn,
                      :times_added_spacing,
                      :times_said_tie,
                      :times_said_win,
                      :times_said_lost,
                      :times_displayed_board
        def initialize
            @times_asked_for_first = 0
            @times_asked_for_play_again = 0
            @times_said_ai_turn = 0
            @times_added_spacing = 0
            @times_said_tie = 0
            @times_said_win = 0
            @times_said_lost = 0
            @times_displayed_board = 0
        end
        def ask_for_first
            @times_asked_for_first += 1
        end
        def ask_for_play_again
            @times_asked_for_play_again += 1
        end
        def say_ai_turn
            @times_said_ai_turn += 1
        end
        def add_spacing
            @times_added_spacing += 1
        end
        def say_tie
            @times_said_tie += 1
        end
        def say_win
            @times_said_win += 1
        end
        def say_lost
            @times_said_lost += 1
        end
        def display_board(b)
            @times_displayed_board += 1
        end
    end
    class MockReader
        attr_accessor :times_read, :responses
        def initialize
            @times_read = 0
        end
        def read_first_letter
            @times_read += 1
            @responses.shift
        end
    end
end
