require "colorize"
class Game
  attr_accessor :board, :rows

  def self.start
    self.new
  end

  def initialize
    @rows = [[]]
    @board = Board.new(@rows)
  end

  def quit_check(input)
    if "QUIT" == input
      abort
    end
  end

  class Board
    attr_accessor :rows
    def initialize(rows)
      @rows = rows
    end
    def draw_board
      @rows.each do |row|
        puts row.join()
      end
    end
  end

end

class Hangman < Game
  attr_accessor :word, :game_running

  def initialize
    words = ["SQUAMIFFLE", "CAT", "SKY", "WOBBLE", "MISSPELLING",
      "RUBY", "WHY", "ZIPPER", "GIT", "SQUABBLE", "FILTRUM", "ABRACADABRA",
      "WIFFLE", "WAFFLE", "HUMMINGBIRD", "WICKET", "WICKED", "COLONIAL", "ZEPPLIN"]
    @word = words.sample
    @word_letters = @word.split("")
    @input_list = []
    @guessed_letters = Array.new(@word.length, " _")
    @comparison_array = (Array.new(@word.length, " ")).zip(@word_letters)
    (0 ... @comparison_array.length).each do |index|
      @comparison_array[index] = @comparison_array[index].join
    end
    @rows = [
      ["|", " ", " ", " ", "_", "_", "_", "_", "_", "_", "_"],
      ["|", " ", " ", " ", "|", "/", " ", " ", " ", " ", "|"],
      ["|", " ", " ", " ", "|", " ", " ", " ", " ", " "],
      ["|", " ", " ", " ", "|", " ", " ", " ", " ", " ", " ", " "],
      ["|", " ", " ", " ", "|", " ", " ", " ", " ", " ", " "],
      ["|", " ", " ", " ", "|", " ", " ", " ", " ", " ", " "],
      ["|", " ", " ", " ", "|"],
      ["|", " ", "_", "_", "|", "_", "_", " ", " ", " "],
      ["Wrong letters: "],
      ["Wrong words: "]]
    @board = Board.new(@rows)
    @game_running = true
    @guy = Guy.new
    run
  end

  def run
    @rows[-3] << @guessed_letters.join
    puts "Let's play hangman!\nTo quit at any time, type \"quit\"."
    while @game_running == true
      @board.draw_board
      puts "Type a letter, or the word."
      input = gets.chomp.upcase
      if @input_list.include?(input)
        puts "You already guessed that letter"
        next
      end
      @input_list << input
      quit_check(input)
      input_check(input)
    end
    @board.draw_board
  end

  def input_check(input)
    if input.length == 1
      letter_check(input)
    elsif input.length == @word.length
      word_check(input)
    else
      puts "Either one letter, or the whole word.\nPlease try again."
    end
  end

  def letter_check(input)
    if @word_letters.include?(input)
      (0 ... @word.length).each do |num|
        if @word_letters[num] == input
          @guessed_letters[num] = " " + input
        end
      end
      @rows[-3][10 .. -1] = @guessed_letters
    else
      @rows[-2] << input + ", "
      wrong
    end
    if @guessed_letters == @comparison_array
      puts "That's right, you've won!"
      @game_running = false
    end
  end

  def word_check(input)
    if input == @word
      puts "That's right, you've won!"
      @rows[-3][10 .. -1] = @comparison_array.join
      @game_running = false
    else
      @rows[-1] << input + ", "
      wrong
    end
  end

  def wrong
    puts "That was not correct."
    body_part = @guy.add_body_part
    dbp = body_part[0]
    coords = body_part[1]
    @rows[coords[0]][coords[1]] = dbp
    if @guy.alive == false
      puts "You didn't guess fast enough, hangman has been hanged."
      @game_running = false
    end
  end

  class Guy
    attr_accessor :alive

    def initialize
      @body_parts = {
        head: ["(_)".colorize(:red), [ 2, -1]],
        neck: ["|".colorize(:black), [3, -2]],
        r_arm: ["\\".colorize(:green), [3, -3]],
        l_arm: ["/".colorize(:green), [3, -1]],
        torso: ["|".colorize(:green), [4, -1]],
        r_leg: ["/ ".colorize(:blue), [5, -2]],
        l_leg: ["\\".colorize(:blue), [5, -1]]}
      @alive = true
      @available_parts = [:l_leg, :r_leg, :torso, :l_arm, :r_arm, :neck, :head]
    end

    def add_body_part
      part = @available_parts.pop
      if part ==:l_leg
        @alive = false
      end
      @body_parts[part]
    end

  end
end
