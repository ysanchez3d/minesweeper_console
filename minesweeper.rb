require_relative 'board'

class MineSweeper
    attr_reader :board

    def initialize(size=9)
        @board = Board.new(size)
    end

    def welcome
        puts "Lets a play a game of Minesweeper!"
    end

    def play
        welcome
        while !board.game_over?
            board.render
            cmd, pos = get_cmd, get_pos
            if cmd == "r"
                #bombs are added away from the neighbors of the first revealed tile
                if !board.bombs_added?
                    board.add_bombs_away_from(pos)
                end
                board.reveal(pos)
            elsif cmd == "f"
                board.flag(pos)
            end

            if board.lose?
                puts "LOSER!, you hit a mine!"
                return
            elsif board.win?
                puts "You Won!"
                return
            end
        end
    end


    def get_cmd
        puts "Enter command: f = flag/unflag | r = reveal"

        cmd = nil
        while cmd.nil? || !valid_cmd?(cmd)
            print "> "
            cmd = gets.chomp.downcase
        end
        cmd
    end

    def valid_cmd?(cmd)
        cmd.length == 1 && "rf".include?(cmd)
    end

    def get_pos
        pos = nil
        puts "Enter a position to reveal a square (ex: 2,3)"
        while pos.nil? || board.valid_pos?(pos)
            pos = gets.chomp.split(",").map(&:to_i)
        end
        pos
    end

    def game_over?

    end
end