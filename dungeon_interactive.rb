# Setting a player
puts "Welcome to Dungeon!"
puts "Enter your name:"
print ">"
name = gets.strip
# name = "User" # Temporal feature for easing the manual testing

# Set a player
me = Player.new(name)
my_dungeon = Dungeon.new(me)

# Add rooms to the dungeon
my_dungeon.add_room(:largecave,
                    "\nMAZE \nLarge Cave",
                    "You are in a large cavernous cave. There's a note on the floor. Enter 'read the note' to read it.",
                    { north: :empty_room, east: :troll_room, south: :room_3, west: :room_2 })

my_dungeon.add_room(:smallcave,
                    "Small Cave",
                    "You are in a small, claustrophobic cave. You see a grate on the ceiling.",
                    { up: :outside })

my_dungeon.add_room(:outside,
                    "Outside",
                    "You see stars on the sky. You are in a forest, with trees in all directions around you. You escaped from the prison.",
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
                    { south: :largecave})

my_dungeon.add_room(:round_room,
                    "Round Room",
                    "",
                    {})

my_dungeon.add_room(:room_2,
                    "Room 2",
                    "You are in another room.",
                    { east: :largecave, south: :room_4, west: :dead_room })

my_dungeon.add_room(:room_3,
                    "Room 3",
                    "You are in another room.",
                    { north: :room_2, south: :largecave, east: :room_4 })

my_dungeon.add_room(:room_4,
                    "Room 4",
                    "You are in another room.",
                    { north: :room_2, west: :room_3, up: :room_5 })

my_dungeon.add_room(:room_5,
                    "Room 5",
                    "You are in another room.",
                    { north: :room_4, south: :room_6 })

my_dungeon.add_room(:room_6,
                    "Room 6",
                    "You are in another room.",
                    { east: :room_5, west: :round_room, up: :room_7 })

my_dungeon.add_room(:room_7,
                    "Room 7",
                    "You are in another room.",
                    { north: :room_6, east: :room_11, east_south: :room_8, south: :room_9, west: :room_10, west_north: :round_room })

my_dungeon.add_room(:room_8,
                    "Room 8",
                    "You are in another room.",
                    { east: :room_7, west: :room_9, up: :room_11 })

my_dungeon.add_room(:room_9,
                    "Room 9",
                    "You are in another room.",
                    { east: :room_7, south: :room_8, west: :room_11, down: :room_10 })

my_dungeon.add_room(:room_10,
                    "Room 10",
                    "You are in another room.",
                    { east: :room_9, south_west: :room_11, west: :room_5, up: :room_7 })

my_dungeon.add_room(:room_11,
                    "Room 11",
                    "You are in another room.",
                    { north_east: :smallcave, west: :room_10, west_north: :room_9, down: :room_8 })

# Set some other stuff
oliver_says = ["Yep?", "Did you call me?", "You know my name?", "What?", "It's me", "Always with you", "Stay awesome", "My friends used to call me like this", "Do 22 push-ups and get my respect", "I'm working out now", "Are you bored by the game?", "Need help?", "Need help? Type 'help' command", "Need something?", "Hi", "Hey!", "The Ruby programming language", "Oliver is a great guy", "Got a question?"]
oliver_says.push("Wanna talk about something?", "Want to tell me something?", "You like me?", "I know you. You are #{name}", "#{name}?")
hello = ["Good day.", "Hello.", "Have a good day", "Nice weather we've been having lately."]
stopwords = %w{the a by on for of are with just but and to the my I has some in}
note_at_largecave = "Hi, #{name}! Welcome to Dungeon.

You are in a prison. You don't know how you got here, where is it and how long have you been here. So many questions...
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
  previous_room = my_dungeon.player.location
  print ">"
  command = gets.strip.downcase
  command = command.scan(/\w+/)
  command = command.reject { |word| stopwords.include?(word) }
  command = command.join(" ")
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
  when "north east"
    unless my_dungeon.find_room_in_direction(:north_east).nil?
      my_dungeon.go(:north_east)
    else
      puts "You can't go that way."
    end
  when "east south"
    unless my_dungeon.find_room_in_direction(:east_south).nil?
      my_dungeon.go(:east_south)
    else
      puts "You can't go that way."
    end
  when "south west"
    unless my_dungeon.find_room_in_direction(:south_west).nil?
      my_dungeon.go(:south_west)
    else
      puts "You can't go that way."
    end
  when "west north"
    unless my_dungeon.find_room_in_direction(:west_north).nil?
      my_dungeon.go(:west_north)
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
      puts note_at_largecave
    else
      puts "I don't see any."
    end
  when "hello"
    puts hello.sample
  when "thank you"
    puts "You're welcome."
  when "oliver"
    puts oliver_says.sample
  when ""

  else
    puts "I don't understand that."
  end

  if my_dungeon.player.location == :dead_room
    won_or_lose = :lose
    puts "Try again?(Y/n)"
    begin
      answer = gets.strip.downcase
      if answer == "n" || answer == "no"
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
        command = "quit"
      elsif answer == "y" || answer == "yes"
        puts "Ok bro! Be careful next time."
        my_dungeon.start(:largecave)
      else
        puts "I don't understand that."
      end
    end until answer == "n" || answer == "no" || answer == "y" || answer == "yes"
  end

  if my_dungeon.player.location == :round_room
    puts "You got to round room and returned back to previous room."
    my_dungeon.start(previous_room)
  end

  if my_dungeon.player.location == :outside
    unless won_or_lose
      won_or_lose = :won
      puts "You won!"
      puts "Exit the game?(Y/n)"
      command = "quit" if gets.strip.downcase == "y"
    end
  end
end
