require 'matrix'

class ToySimulatorError < StandardError
end

class PlaceError < ToySimulatorError
  def message
    'First Place your Robot.'
  end
end

class PositionError < ToySimulatorError
  def message
    'Enter valid grid position.'
  end
end

class CommandIgnored < ToySimulatorError
  def message
    'You are on edge of table Be cafeful.'
  end
end

class Robot
  DIRECTIONS = %w[south west north east].freeze

  def initialize(size)
    @board_size = size
    @board = Matrix.build(size)
    @is_placed = false
  end

  def start_game
    puts "your table is of size #{@board_size}"
    getCommand
  end

  def is_not_valid_move?
    (((@current_postion_i == (@board_size - 1)) && @facing == 'north') ||
        ((@current_postion_i == 0) && @facing == 'south')) ||
      (((@current_postion_j == (@board_size - 1)) && @facing == 'east') ||
          ((@current_postion_j == 0) && @facing == 'west'))
  end

  def move
    raise PlaceError unless @is_placed
    raise CommandIgnored if is_not_valid_move?

    case @facing
    when 'south'
      @current_postion_i -= 1
    when 'west'
      @current_postion_j -= 1
    when 'east'
      @current_postion_j += 1
    when 'north'
      @current_postion_i += 1
    end
    report
    getCommand
  end

  def right
    raise PlaceError unless @is_placed

    direction_index = DIRECTIONS.find_index(@facing).to_i
    direction_index -= 1
    @facing = DIRECTIONS[(direction_index == -1 ? 3 : direction_index)]
    report
    getCommand
  end

  def left
    raise PlaceError unless @is_placed

    direction_index = DIRECTIONS.find_index(@facing).to_i
    direction_index += 1
    @facing = DIRECTIONS[(direction_index == 4 ? 0 : direction_index)]
    report
  end

  def report
    raise PlaceError unless @is_placed

    puts "Robot currently placed at #{@current_postion_i}, #{@current_postion_j} facing #{@facing} direction"
    getCommand
  end

  def place(args_string)
    @current_postion_i, @current_postion_j, @facing = args_string&.split(',')
    if (@current_postion_i.to_i >= @board_size) || (@current_postion_j.to_i >= @board_size)
      raise PositionError
    end

    @current_postion_i = @current_postion_i.to_i || 0
    @current_postion_j = @current_postion_j.to_i || 0
    @facing = @facing && DIRECTIONS.include?(@facing&.strip&.downcase) ? @facing&.strip&.downcase : DIRECTIONS.first
    @is_placed = true

    puts "Robot placed at #{@current_postion_i}, #{@current_postion_j}, #{@facing}"
    getCommand
  end

  def getCommand
    puts 'Enter command for robot, valid commands are: place move, left, right, report, exit'
    command = gets.chomp.split(' ', 2)
    prepared_command = command.first
    prepared_command = prepared_command&.downcase&.strip

    if prepared_command != 'place'
      send(prepared_command)
    elsif prepared_command == 'place'
      place command.last
    else
      puts 'You better enter a valid command'
    end
  rescue ToySimulatorError => e
    puts e.message
    report if e.instance_of?(CommandIgnored)
    getCommand
  end
end

puts 'Enter your board size'

robot = Robot.new(gets.chomp.to_i)

robot.start_game
