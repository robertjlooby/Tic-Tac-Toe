require 'test/unit'
require 'stringio'
require_relative '../src/player'

class PlayerWriterTests < Test::Unit::TestCase
    def setup
        @stream = StringIO.new
        @writer = Player::Writer
    end
    def test_ask_for_cell
        @writer.ask_for_cell(:X, @stream)
        @stream.rewind
        assert(@stream.gets =~ /you are [XO]'s/)
    end
    def test_notify_invalid_cell
        @writer.notify_invalid_cell(@stream)
        @stream.rewind
        assert(@stream.gets =~ /not valid!/)
    end
end
