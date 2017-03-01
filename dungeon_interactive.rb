# Setting a player
puts "Welcome to Dungeon. With love by Oliver"
puts "Enter your name:"
print ">"
# name = gets.strip
name = "User" # Temporal feature for easing manual testing

# Set a player
me = Player.new(name)
my_dungeon = Dungeon.new(me)
puts "Hi, #{my_dungeon.player.name}"
my_dungeon.player.score = 0

# Add rooms to the dungeon
my_dungeon.add_room(:largecave,
                    "Large Cave",
                    "a large cavernous cave",
                    { :west => :smallcave })

my_dungeon.add_room(:smallcave,
                    "Small Cave",
                    "a small, claustrophobic cave. You see a door on the ceiling.",
                    { :east => :largecave, :up => :outside })

my_dungeon.add_room(:outside,
                    "Outside",
                    "an open world. You see stars on the sky. You escaped from the prison.",
                    { :down => :smallcave })

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
    The 'SCORE' command prints your current score.
    The 'TIME' command tells you how long you have been playing.

Directions:
    WEST, EAST, NORTH, SOUTH, UP, DOWN.
"
won_or_lose = false
until command == "quit" || !!won_or_lose do
  print ">"
  command = gets.strip.downcase
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
  when "score"
    puts "Your score is #{my_dungeon.player.score}"
  when "info"
    puts File.read("../info.txt")
  when "time"
    puts "You have been playing Dungeon for #{Time.at(Time.now - time_of_start).min} minutes."
  end

  if my_dungeon.player.location == :outside
    won_or_lose = :won
    puts "You won!"
    puts "Your score is #{my_dungeon.player.score}"
  end
end
