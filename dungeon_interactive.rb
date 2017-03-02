# Setting a player
puts "Welcome to Dungeon!"
puts "Enter your name:"
print ">"
# name = gets.strip
name = "User" # Temporal feature for easing the manual testing

# Set a player
me = Player.new(name)
my_dungeon = Dungeon.new(me)
# puts "Hi, #{my_dungeon.player.name}"

# Add rooms to the dungeon
my_dungeon.add_room(:largecave,
                    "\nMAZE \nLarge Cave",
                    "You are in a large cavernous cave. There's a note on the floor. Enter 'read the note' to read it.",
                    { west: :room_2, north: :empty_room, east: :troll_room })

my_dungeon.add_room(:smallcave,
                    "Small Cave",
                    "You are in a small, claustrophobic cave. You see a grate on the ceiling.",
                    { up: :outside })

my_dungeon.add_room(:outside,
                    "Outside",
                    "You are outside. You see stars on the sky. You escaped from the prison.",
                    { down: :smallcave })

my_dungeon.add_room(:dead_room,
                    "Dead End",
                    "Oh no! You got in a trap. Unfortunately, you are dead.",
                    { east: :room_2 })

my_dungeon.add_room(:troll_room,
                    "Troll Room",
                    "Goddamnit! What is this monster doing here? The Troll are gonna kill you. Do you want me to rescue you?(y/n)",
                    { south: :largecave })

my_dungeon.add_room(:empty_room,
                    "Empty Room",
                    "You are in an empty room. It smells like here was a dog.",
                    {south: :largecave})

my_dungeon.add_room(:room_2,
                    "Room 2",
                    "You are in another room.",
                    {east: :largecave, west: :dead_room })

# Set some other stuff
oliver_says = ["Yep?", "Did you call me?", "You know my name?", "What?", "It's me", "Always with you", "Stay awesome", "My friends used to call me like this", "Do 22 push-ups and get my respect", "I'm working out now", "Are you bored by the game?", "Need help?", "Need help? Type 'help' command", "Need something?", "Hi", "Hey!", "The Ruby programming language", "Oliver is a great guy", "Got a question?"]
oliver_says.push("Wanna talk about something?", "Want to tell me something?", "You like me?", "I know you. You are #{name}", "#{name}?")
hello = ["Good day.", "Hello.", "Have a good day", "Nice weather we've been having lately."]
stopwords = %w{the a by on for of are with just but and to the my I has some in}
note_in_largecave = "Hi, #{name}! Welcome to Dungeon.
  You are in a prison. You don't know how you got here, where it is and how long have you been here. So many questions...
  But now, try to get out of this maze!
  Always with you,
  Oliver"

# Start the dungeon by placing the player in the large cave
my_dungeon.start(:largecave)
time_of_start = Time.new
command = ""
help = "Useful commands:

    The 'INFO' command prints information which might give some idea
 of what the game is about.
    The 'QUIT' command prints your score and asks whether you wish
 to continue playing.
    The 'LOOK' command prints a description of your surroundings.
    The 'TIME' command tells you how long you have been playing.

Directions:
    WEST, EAST, NORTH, SOUTH, UP, DOWN, etc.

    Note: You don't necessarily have to type them in upper case.
"
won_or_lose = false
until command == "quit" do
  print ">"
  command = gets.strip.downcase
  command = command.scan(/\w+/)
  command = command.reject { |word| stopwords.include?(word) }
  command = command.join(" ")
  puts "########## You entered: #{command}"
  case command
  when "quit"
    puts "Do you wish to leave the game?(yes/no)"
    print ">"
    command = gets.strip.downcase
    if command == "yes"
      command = "quit"
    else
      command = ""
    end
  when "help"
    puts help
  when "look"
    puts my_dungeon.show_current_description
  when "west"
    unless my_dungeon.find_room_in_direction(:west).nil?
      my_dungeon.go(:west)
    else
      puts "You can't go that way."
    end
  when "east"
    unless my_dungeon.find_room_in_direction(:east).nil?
      my_dungeon.go(:east)
    else
      puts "You can't go that way."
    end
  when "north"
    unless my_dungeon.find_room_in_direction(:north).nil?
      my_dungeon.go(:north)
    else
      puts "You can't go that way."
    end
  when "south"
    unless my_dungeon.find_room_in_direction(:south).nil?
      my_dungeon.go(:south)
    else
      puts "You can't go that way."
    end
  when "up"
    unless my_dungeon.find_room_in_direction(:up).nil?
      my_dungeon.go(:up)
    else
      puts "You can't go that way."
    end
  when "down"
    unless my_dungeon.find_room_in_direction(:down).nil?
      my_dungeon.go(:down)
    else
      puts "You can't go that way."
    end
  when "info"
    puts File.read("./info.txt")
  when "time"
    puts "You have been playing Dungeon for #{Time.at(Time.now - time_of_start).min} minutes."
  when "read note"
    if my_dungeon.player.location == :largecave
      puts note_in_largecave
    else
      puts "I don't see any."
    end
  when "hello"
    puts hello.sample
  when "thank you"
    puts "You're welcome."
  when "oliver"
    puts oliver_says.sample
  else
    puts "I don't understand that."
  end

  if my_dungeon.player.location == :dead_room
    won_or_lose = :lose
    puts "Try again?(Y/n)"
    begin
      answer = gets.strip.downcase
      if answer == "n" || answer == "no"
        puts "###################### End of the game"
        command = "quit"
      elsif answer == "y" || answer == "yes"
        my_dungeon.start(:largecave)
      else
        puts "I don't understand that."
      end
    end until answer == "n" || answer == "no" || answer == "y" || answer == "yes"
  end

  if my_dungeon.player.location == :troll_room
    begin
      answer = gets.strip.downcase
      if answer == "n" || answer == "no"
        puts "You were killed by the troll. \n\n Sometimes people don't trust me. \n \t But that's okay."
        puts "###################### End of the game"
        command = "quit"
      elsif answer == "y" || answer == "yes"
        puts "Ok bro! Be careful next time."
        my_dungeon.start(:largecave)
      else
        puts "I don't understand that."
      end
    end until answer == "n" || answer == "no" || answer == "y" || answer == "yes"
  end

  if my_dungeon.player.location == :outside
    unless won_or_lose
      won_or_lose = :won
      puts "You won!"
      puts "End the game?(Y/n)"
      command = "quit" if gets.strip.downcase == "y"
    end
  end
end
