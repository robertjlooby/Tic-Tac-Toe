# encoding: UTF-8
require 'test/unit'
require 'stringio'
require_relative '../src/tic_tac_toe'

class TicTacToeWriterTests < Test::Unit::TestCase
    def setup
        @stream = StringIO.new
        @writer = TicTacToe::Writer
    end
    def test_ask_for_first
        @writer.ask_for_first(@stream)
        @stream.rewind
        assert(@stream.gets =~ /like to go first/)
    end
    def test_ask_for_play_again
        @writer.ask_for_play_again(@stream)
        @stream.rewind
        assert(@stream.gets =~ /like to play again/)
    end
    def test_say_ai_turn
        @writer.say_ai_turn(@stream)
        @stream.rewind
        assert(@stream.gets =~ /AIPlayer's turn/)
    end
    def test_add_spacing
        @writer.add_spacing(@stream)
        @stream.rewind
        assert(@stream.gets(".") =~ /\n\n/)
    end
    def test_say_tie
        @writer.say_tie(@stream)
        @stream.rewind
        assert(@stream.gets =~ /a tie/)
    end
    def test_say_win
        @writer.say_win(@stream)
        @stream.rewind
        assert(@stream.gets =~ /won/)
    end
    def test_say_lost
        @writer.say_lost(@stream)
        @stream.rewind
        assert(@stream.gets =~ /lost/)
    end
    def test_display_empty_board
        b = Board.new
        @writer.display_board(b, @stream)
        @stream.rewind
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("  0┃  1┃  2\n", @stream.gets) 
        assert_equal("━━━╋━━━╋━━━\n", @stream.gets) 
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("  3┃  4┃  5\n", @stream.gets) 
        assert_equal("━━━╋━━━╋━━━\n", @stream.gets) 
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("   ┃   ┃   \n", @stream.gets) 
        assert_equal("  6┃  7┃  8\n", @stream.gets)
        
    end
    def test_display_board
        b = Board.new([[:X, :O, :X], [:O, :O, :X], [:X, :X, :O]], :O)
        @writer.display_board(b, @stream)
        @stream.rewind
        assert_equal("╲ ╱┃┌─┐┃╲ ╱\n", @stream.gets) 
        assert_equal(" ╳ ┃│ │┃ ╳ \n", @stream.gets) 
        assert_equal("╱ ╲┃└─┘┃╱ ╲\n", @stream.gets) 
        assert_equal("━━━╋━━━╋━━━\n", @stream.gets) 
        assert_equal("┌─┐┃┌─┐┃╲ ╱\n", @stream.gets) 
        assert_equal("│ │┃│ │┃ ╳ \n", @stream.gets) 
        assert_equal("└─┘┃└─┘┃╱ ╲\n", @stream.gets) 
        assert_equal("━━━╋━━━╋━━━\n", @stream.gets) 
        assert_equal("╲ ╱┃╲ ╱┃┌─┐\n", @stream.gets) 
        assert_equal(" ╳ ┃ ╳ ┃│ │\n", @stream.gets) 
        assert_equal("╱ ╲┃╱ ╲┃└─┘\n", @stream.gets)
    end
end
