require_relative 'board'

class MineSweeper
    LEVELS = {
        :beginner => {:grid_size => 5, :bombs => 4},
        :intermediate => {:grid_size => 7, :bombs => 8},
        :expert => {:grid_size => 10, :bombs => 13}
    }

    attr_reader :board, :bomb_flags

    def self.ask_difficulty_level
        puts "Pick a level: 1 = beginner, 2 = intermediate, 3 = expert"
        lvl = gets.chomp.to_i
        case lvl
        when 1
            :beginner
        when 2
            :intermediate
        when 3
            :expert
        else
            :beginner
        end
    end

    def initialize(difficulty = :beginner)
        @board = Board.new(LEVELS[difficulty])
        @bomb_flags = LEVELS[difficulty][:bombs]
        @time_game_started = nil
        
    end

    def welcome
        puts "Lets a play a game of Minesweeper!"
    end

    def play
        welcome
        while !game_over?
            show_stats
            board.render
            cmd, pos = get_cmd, get_pos
            system("clear")
            process_command(cmd, pos)

            if lose?
                board.reveal_all_bombs
                show_stats
                board.render
                puts "LOSER!, you hit a mine!"
                return
            elsif win?
                show_stats
                board.render
                puts "You Won!"
                return
            end
        end
    end

    def lose?
        board.lose?
    end

    def win?
        board.win?
    end

    def process_command(cmd, pos)
        tile = board[pos]
        if cmd == "r"
            #bombs are added away from the neighbors of the first revealed tile
            if !board.bombs_added?
                board.add_bombs_away_from(pos)
                @time_game_started = Time.now.to_i
            end

            if tile.flagged?
                puts "Yout must unflag this square before revealing it."
            else
                board.reveal(pos)
            end
        elsif cmd == "f"
            if tile.revealed?
                puts "Cannot flag a revealed square"
            else
                tile.flagged? ? @bomb_flags += 1 : @bomb_flags -= 1
                board.flag(pos)
            end
        end
    end

    def show_stats
        time_now = Time.now.to_i
        puts "Bombs left: #{bomb_flags} | Time: #{ @time_game_started.nil? ? "000" : time_now - @time_game_started}".colorize(:yellow)
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
        if !(cmd.length == 1 && "rf".split("").include?(cmd))
            puts "Invalid Command, try again."
            return false
        end
        true
    end

    def get_pos
        pos = nil
        puts "Enter a position (ex: 2,3)"
        while pos.nil? || !valid_pos?(pos)
            print "> "
            pos = gets.chomp.split(",").map(&:to_i)
        end
        pos
    end

    def valid_pos?(pos)
        if !board.valid_pos?(pos)
            puts "Invalid position, try again."
            return false
        end
        true
    end

    def game_over?
        board.game_over?
    end
end


if __FILE__ == $PROGRAM_NAME
    game = MineSweeper.new(MineSweeper.ask_difficulty_level)
    game.play
end