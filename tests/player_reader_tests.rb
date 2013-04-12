require 'test/unit'
require 'stringio'
require_relative '../src/player'

class PlayerReaderTests < Test::Unit::TestCase
    def read(input)
        i_stream = StringIO.new(input)
        Player::Reader.read_cell(i_stream)
    end
    def test_reader_with_ints
        assert_equal("0", read("0"))
        assert_equal("5", read("5"))
    end
    def test_reader_with_extra_spaces
        assert_equal("3", read("   3      "))
    end
    def test_reader_with_strings
        assert_equal("123abc", read("123abc"))
        assert_equal("Hello", read("Hello"))
    end
end
