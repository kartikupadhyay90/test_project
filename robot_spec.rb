require 'stringio'
require './robot'

RSpec.describe Robot do

  let (:robot) { described_class.new(5) }
  let (:direction_x) { 2 }
  let (:direction_y) { 1 }
  let (:facing) { Robot::DIRECTIONS.first }

  before { allow($stdout).to receive(:write) }
  context 'when robot is not placed' do
    ['move', 'left', 'right', 'report'].each do |command|
      describe "# #{command}" do
        it 'should raise error' do
          expect { robot.send(command) }.to raise_error(PlaceError)
        end
      end
    end

    describe '#place' do
      it 'should place the robot' do
        expect { robot.place('0, 0, north') }.to output("Robot currently placed at 0, 0 facing north direction\n").to_stdout
      end
    end
  end

  context 'when robot is placed facing valid direction (Non-edge)' do
    before(:each) do
      robot.place("#{direction_x}, #{direction_y}, #{facing}")
    end

    describe '#move' do
      it 'should move one block' do
        validate_position_and_direction('move', direction_x - 1, direction_y, facing)
      end
    end

    describe '#left' do
      it 'should turn left on same position' do
        validate_position_and_direction('left', direction_x, direction_y, 'west')
      end
    end

    describe '#right' do
      it 'should turn right on same position' do
        validate_position_and_direction('right', direction_x, direction_y, 'east')
      end
    end

    describe '#report' do
      it 'should report without any movement' do
        validate_position_and_direction('report', direction_x, direction_y, facing)
      end
    end

    describe '#place' do
      it 'should place the robot' do
        direction_x = 1
        direction_y = 2
        facing = 'north'
        validate_position_and_direction("place", direction_x, direction_y, facing, "#{direction_x}, #{direction_y}, #{facing}")
      end
    end
  end

  def validate_position_and_direction(command, direction_x, direction_y, facing, args = '')
    expect {
      command == 'place' ? robot.send(command, args) : robot.send(command)
    }.to output("Robot currently placed at #{direction_x}, #{direction_y} facing #{facing} direction\n").to_stdout
  end

end