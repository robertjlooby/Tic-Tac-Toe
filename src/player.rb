class Player
    attr_reader :sym
    def initialize(n)
        # holds whether the player's symbol(:X or :O)
        @sym = n
    end
    
    # Prompts the player for their move for a given board state and returns the 
    # move the player selects.
    # Will only accept moves for open board positions.
    def get_move(brd, reader = Reader, writer = Writer)
        # Prompt user for the row/column until they enter a valid cell, where valid means
        # both are 0, 1, or 2 and that cell is still open
        writer.ask_for_cell(@sym)
        cell = reader.read_cell
        if ("0".."8").include?(cell)
            r = cell.to_i/3
            c = cell.to_i%3
            if brd.board_state[r][c].nil?
                return r, c
            end
        end
        writer.notify_invalid_cell
        get_move(brd, reader, writer)
    end

    class Writer
        def self.ask_for_cell(sym, o_stream = $stdout)
            o_stream.puts "Where would you like to move? (you are #{sym.to_s}'s, enter the cell number)"
        end
        def self.notify_invalid_cell(o_stream = $stdout)
            o_stream.puts "The cell you entered was not valid!"
        end
    end
    class Reader
        def self.read_cell(i_stream = $stdin)
            i_stream.gets.chomp.strip
        end
    end
end
