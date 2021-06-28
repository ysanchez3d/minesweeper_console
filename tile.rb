class Tile
    attr_reader :board, :position

    def initialize(position, board)
        @position = position
        @board = board
        @bombed = false
        @flagged = false
        @revealed = false
    end

    def neighbors
        row, col = position
        top_neighbors, side_neighbors, bottom_neighbors = [], [], []
        
        (col-1..col+1).each do |col|
            top_pos, btm_pos, sde_pos = [row-1, col], [row+1, col], [row, col]
            top_neighbors << board[top_pos] if board.valid_pos?(top_pos)
            bottom_neighbors << board[btm_pos] if board.valid_pos?(btm_pos)
            side_neighbors << board[sde_pos] if board.valid_pos?(sde_pos) && board[sde_pos] != self
        end
        top_neighbors + side_neighbors + bottom_neighbors
    end

    def neighbor_bomb_count
        self.neighbors.count { |tile| tile.bombed? }
    end

    def bombed?
        @bombed
    end

    def add_bomb
        @bombed = true
    end

    def flag
        @flagged = !@flagged
    end

    def flagged?
        @flagged
    end

    def revealed?
        @revealed
    end

    def reveal
        @revealed = true
    end

    def inspect
        self.to_s
    end

    def to_s_cheat
        return "B" if bombed?
        return "F" if flagged?

        if revealed?
            nbc = neighbor_bomb_count
            nbc.zero? ? "_" : nbc.to_s 
        else
            "*"
        end
    end

    def to_s
        return "F" if flagged?

        if revealed?
            nbc = neighbor_bomb_count
            nbc.zero? ? "_" : nbc.to_s 
        else
            "*"
        end
    end
end