require 'stringio'
require './robot'

RSpec.describe Robot do

  let (:robot) { described_class.new(5) }

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
      robot.place('0, 0, east')
    end

    describe '#move' do
      it 'should move one block' do
        expect { robot.move }.to output("Robot currently placed at 0, 1 facing east direction\n").to_stdout
      end
    end

    describe '#place' do
      it 'should place the robot' do
        expect { robot.place('0, 4, west') }.to output("Robot currently placed at 0, 4 facing west direction\n").to_stdout
      end
    end

  end

end