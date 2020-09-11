require 'stringio'
require './robot'

RSpec.describe Robot do

  let (:robot) { described_class.new(5) }

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

end