require './dream_dragon.rb'
require './dream_hangman.rb'
require './dream_mastermind.rb'

class BigDream
  attr_accessor :name, :person, :subdreams, :friends

  def initialize(name, lildreams, buddies)
    @person = Person.new(name)
    @subdreams = []
    @friends = []
    @things = []
    lildreams.each do |lildream|
      @subdreams << SubDream.new(lildream[0], lildream[1], lildream[2], lildream[3], lildream[4], lildream[5])
    end
    buddies.each do |buddy|
      @friends << Friend.new(buddy[0], buddy[1], buddy[2], buddy[3], buddy[4])
    end

  end


  def find_friend(location)
    friend = false
    @friends.each do |f|
      if f.location == location.reference
        friend = f
      else
        next
      end
    end
    return friend
  end

  def show_current_description
    puts find_dream(@person.location).full_description
  end

  def find_dream(reference)
    @subdreams.detect { |dream| dream.reference == reference}
  end

  def find_connected_dream(feeling)
    find_dream(@person.location).connections[feeling.to_sym]
  end

  def go(feeling)
    puts "You feel #{feeling.to_s}. You drift away and find yourself elsewhere..."
    @person.location = find_connected_dream(feeling)
  end

  class Person
    attr_accessor :name, :location, :inventory

    def initialize(name)
      @name = name
      @inventory = []
    end
  end

  class Friend
    attr_accessor :name, :location, :description, :attitude, :extra

    def initialize(name, location, description, attitude, extra = nil)
      @name = name
      @location = location
      @description = description
      @attitude = attitude
      @extra = extra
    end
  end

  class SubDream
    attr_accessor :reference, :name, :description, :connections, :interactivity, :result
    def initialize(reference, name, description, connections, interactivity, result)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
      @interactivity = interactivity
      @result = result
    end

    def full_description
      '*'*80 + "\n" + @name + "\n\nYou're " + @description
    end

  end
end

class Run
  attr_accessor :dream
  def initialize(dream)
    @dream=dream
  end

  def start(location, input = nil)
    @dream.person.location = location
    while true
      location = @dream.find_dream(@dream.person.location)
      @dream.show_current_description
      input = doing_stuff(location)
      input = feelings(location)
    end
  end

  def doing_stuff(location)
    puts "Let's look around."
    friend = @dream.find_friend(location)
    if friend
      chit_chat(friend)
    end
    puts "Look at that!\n#{location.interactivity}\nWant to check it out?"
    input = gets.chomp.downcase
    quit_check(input)
    if input == "yes"
      puts "#{location.result}"
    end
  end

  def play_a_game(friend)
    if friend.extra == :Hangman
      puts "#{friend.name.capitalize} says: \"Oooh, let's play hangman! It's Kim's favorite!\""
      Hangman.start
      puts "Kanye says, \"Thanks for playing!\""
    elsif friend.extra == :MasterMind
      puts "The pirate says: \"Fantastic! My favorite game is Master Mind!\""
      MasterMind.start
      puts "The pirate says, \"Thanks for playing!\""
    elsif friend.extra == :Dragon
      puts "The Octocat smiles broadly at you\n(in a way that makes you worry about this game),\nand flicks a tentacle in the direction of a large egg nearby.\nThe shell cracks and..."
      Dragon.start
      puts "The Octocat sneers at your inability to properly raise dragon spawn."
    end

    #FIGURE OUT HOW TO GET BACK INTO THE RUN LOOP AFTER THE GAMES.


  end

  def chit_chat(friend)
    puts "Hey, look, it's #{friend.name}. #{friend.description}\nWant to chat?"
    input = gets.chomp.downcase
    quit_check(input)
    if input == "yes"
      results = {:friendly => "Wow, what a nice conversation. You've made a new friend!",
                 :mean => "\"Mine! It's all mine! MINE!!!\"\nWow, someone never learned about sharing.",
                 :cruel => "The octocat will not speak to you.\nIt looks at you with distain.\nYou must learn more git to earn its respect."}
      puts results[friend.attitude]
      if friend.extra
        puts "Want to play a game with #{friend.name}?"
        input = gets.chomp.downcase
        quit_check(input)
        if input == "yes"
          play_a_game(friend)
        end
      end
    end
  end

  def quit_check(input)
    if ["exit", "i want to wake up!", "wake up!", "end", "quit"].include?(input)
      abort
    end
  end

  def feelings(location)
    options = location.connections
    puts "How are you feeling?"
    options.keys.each do |feeling|
      puts "#{feeling.capitalize}?"
    end
    input = ''
    until options.include?(input)
      input = gets.chomp.downcase.to_sym
      quit_check(input.to_s)
      if !(options.include?(input))
        puts "This isn't lucid dreaming, buddy.\nYou're not in charge.\nPick a feeling."
      end
    end
    @dream.go(input)
  end

end


subdreams = [[:cloud, "The Clouds", "floating among the clouds.\nHow nice.", {curious: :falling, hungry: :jello}, "That cloud looks like a duck!", "QUACK QUACK!\nHow unexpected!"],
             [:jello, "Jello Room", "in a room made of jello! Exciting!\nAlso, sticky.", {relaxed: :suburbs, adventurous: :ship}, "Yellow jello!\nYellow.\nJello.\nJust kidding, the jello is orange.\nI just like rhymes.", "BOING! PBBLLTHHHPPFFTTT!\nIt's jello, not a trampoline. What did you expect?"],
             [:falling, "Falling", "in the sky, falling through the air, feeling no fear! WHEEE!", {light: :cloud, despairing: :pit, adventurous: :ship}, "Clouds! Air! Clouds! Wheee! Look, a bird!", "\"QUACK!\" Must be a duck! Wheeee!"],
             [:suburbs, "Phoenix Suburbs", "walking around a Phoenix suburb.\nBeyonce and Jay-Z are going to perform at the block party tonight!", {tranquil: :halloween, nostalgic: :school}, "A cactus! How green!", "OW! Spikey!\nThat was unwise."],
             [:halloween, "Halloween Night", "walking around a cozy neighborhood on Halloween evening.", {nostalgic: :school, despairing: :pit}, "What a lovely house!\nI wonder if they have any candy left!", "Too old. They said you were too old for candy.\nOuch."],
             [:school, "High School", "at a graduation party! There are lemon bars!", {curious: :falling, adventurous: :ship}, "What wonderful looking lemon bars! Yummy yummy!", "Omnomnomnom!"],
             [:ship, "Pirate Ship", "on the deck of a pirate ship! Arrr!", {light: :cloud, despairing: :pit}, "Sails! A mast! A deck!\nOh right, we're on a ship.\nHey, look at that bottle!", "Yohoho and a bottle of rummmm!"],
             [:pit, "DESPAIR", "in a dark place.\nYOU DIDN'T USE GIT RIGHT.\nNOW YOUR WORK IS GONE.\nTHERE IS ONLY EMPTINESS.", {hungry: :jello}, "NOTHING. THERE IS NOTHING HERE.", "IT'S GONE. GONE FOREVER. SHADAE SAID SO."]]

friends = [["a kangaroo", :jello, "She's floppy-eared and friendly!", :friendly],
           ["Kanye West", :suburbs, "He's casually dressed, biking around on a little bmx bike.", :mean, :Hangman],
           ["a trick-or-treater", :halloween, "He's short, and dressed as an angel.", :mean],
           ["a pirate", :ship, "He's large, brawny, tattooed, and wearing a nice hat", :friendly, :MasterMind],
           ["the octocat", :pit, "Is it sneering at me? It's sneering at me!", :cruel, :Dragon]]

#things = [["spoon", :school, "might be useful for eating jello!", :jello],
#          ["rum bottle", :suburbs, "is full of tasty rum!", :ship],
#          ["piece of candy", :ship, "looks tasty!", :halloween],
#          ["kite", :halloween, "might be fun to play with!", :cloud],
#          ["picture of Kim Kardashian", :jello, "is weird. Just plain old weird.", :suburbs]]

#Get started
puts "What's your name?"
name = gets.chomp
dream = BigDream.new(name, subdreams, friends)

d = Run.new(dream)
d.start(:cloud)
