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
            top_tile, btm_tile, sde_tile = board[top_pos], board[btm_pos], board[sde_pos]
            top_neighbors << top_tile if board.valid_pos?(top_pos)
            bottom_neighbors << btm_tile if board.valid_pos?(btm_pos)
            side_neighbors << sde_tile if board.valid_pos?(sde_pos) && sde_tile != self
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

#pos "M" = [1,4] => [5,6,7,5,3,2,6,4]
#pos "9" = [0,8] => [2,1,8]
#pos "T" = [2,1] => [4,5,1,2,3]
# arr = [
#     [1, 2 ,3,4, 5 ,6,7,8,"9"],
#     [3, 4 ,5,6,"M",7,9,1, 2 ],
#     [2,"T",1,2, 3 ,5,7,8, 1 ]
# ]