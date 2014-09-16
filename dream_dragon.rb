class Dragon

  def self.start
    new("GRAHR")
  end

  def initialize(name)
    @name = name
    @asleep = false
    @stuff_in_belly = 10
    @stuff_in_intestine = 0
    @game_running = true
    @activity_hash = {
      "feed"=> :feed,
      "walk" => :walk,
      "put to bed" => :put_to_bed,
      "toss" => :toss,
      "rock" => :rock}

    puts "#{@name} is born."
    run
  end

  def feed
    puts "You feed #{@name}."
    @stuff_in_belly = 10
    passage_of_time
  end

  def walk
    puts "You walk #{@name}."
    @stuff_in_intestine = 0
    passage_of_time
  end

  def put_to_bed
    puts "You put #{@name} to bed."
    @asleep = true
    3.times do
      if @asleep
        passage_of_time
      end
      if @asleep
        puts "#{@name} snores, filling the room with smoke."
      end
    end
    if @asleep
      @asleep = false
      puts "#{@name} wakes up slowly."
    end
  end

  def toss
    puts "You toss #{@name} up into the air."
    puts "He giggles, which singes your eyebrows."
    passage_of_time
  end

  def rock
    puts "You rock #{@name} gently."
    @asleep = true
    puts "He briefly dozes off..."
    passage_of_time
    if @asleep
      @asleep = false
      puts "...but wakes when you stop"
    end
  end

  private

  def run
    while @game_running == true
      puts "-" * 80
      puts "What would you like to do with #{@name}?"
      @activity_hash.keys.each {|op| puts op.capitalize + "?"}
      input = gets.chomp.downcase
      quit_check(input)
      puts "-" * 80
      if @activity_hash.keys.include?(input)
        send @activity_hash[input]
      end
    end
  end

  def quit_check(input)
    if ["quit", "exit", "end", "done"].include?(input)
      abort
    end
  end

  def hungry?
    @stuff_in_belly <= 2
  end

  def poopy?
    @stuff_in_intestine >= 8
  end

  def wake
    @asleep = false
    puts "He wakes up suddenly!"
  end

  def passage_of_time
    if @stuff_in_belly > 0
      @stuff_in_belly -= 1
      @stuff_in_intestine += 1
    else
      if @asleep
        wake
      end
      puts "#{@name} is starving! In desparation, he ate YOU!"
      @game_running = false
    end
    if @stuff_in_intestine >= 10
      @stuff_in_intestine = 0
      puts "Whoops! #{@name} had an accident..."
    end

    if hungry?
      if @asleep
        wake
      end
      puts "#{@name}'s stomach grumbles..."
    end

    if poopy?
      if @asleep
        wake
      end
      puts "#{@name} does the potty dance..."
    end
  end

end
