require './robot'

puts 'Enter your board size'

robot = Robot.new(gets.chomp.to_i)

robot.start_game