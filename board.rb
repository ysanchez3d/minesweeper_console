require_relative "tile"

class Board
    attr_reader :board, :size, :num_of_bombs

    def initialize(grid_size)
        @size = grid_size
        @board = Array.new(grid_size) { Array.new(grid_size, nil) }
        @bombs_added = false
        @max_bombs = 10
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

    def bombs_added?
        @bombs_added
    end

    def add_bombs_away_from(pos)
        starting_area = self[pos].neighbors
        available_area_randomized = board.flatten.reject { |tile| neighbors.include?(tile) }.shuffle

        max_bombs.times do 
            tile = available_area.shift
            tile.add_bomb
        end
        @bombs_added = true
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

    def reveal(pos)
        self[pos].reveal
    end

    def flag(pos)
        self[pos].flag
    end

    def win?
        board.flatten.reject(&:bombed?).all? { |tile| tile.revealed }
    end

    def lose?
        board.flatten.any? { |tile| tile.bombed? && tile.revealed? }
    end

    def game_over?
        win? || lose
    end
end