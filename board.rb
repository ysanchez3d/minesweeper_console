require_relative "tile"

class Board
    attr_reader :board, :size

    def initialize(grid_size)
        @size = grid_size
        @board = Array.new(grid_size) { Array.new(grid_size, nil) }
        self.populate
    end

    def populate
        (0...size).each do |row|
            (0...size).each do |col|
                pos = [row, col]
                self[pos] = Tile.new(pos, self)
            end
        end
    end

    def valid_pos?(pos)
        pos.all? { |n| n >= 0 && n < size }
    end

    def [](pos)
        row, col = pos
        @board[row][col]
    end

    def []=(pos, val)
        row, col = pos
        @board[row][col] = val
    end

    def render
        puts "  #{(0...size).to_a.join(" ")}"
        board.each_with_index do |row, idx|
            print idx.to_s
            row.each { |tile| print " #{tile}" }
            puts
        end
    end

end