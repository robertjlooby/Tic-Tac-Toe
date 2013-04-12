require 'test/unit'
require 'stringio'
require_relative '../src/tic_tac_toe'

class TicTacToeReaderTests < Test::Unit::TestCase
    def read(input)
        i_stream = StringIO.new(input)
        TicTacToe::Reader.read_first_letter(i_stream)
    end
    def test_reader
        assert_equal("y", read("y"))
        assert_equal("y", read("Y"))
        assert_equal("y", read("Yes"))
        assert_equal(" ", read("  maybe"))
        assert_equal("1", read("123"))
    end
end
