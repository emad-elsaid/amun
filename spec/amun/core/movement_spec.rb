require_relative '../../spec_helper'

describe 'amun/core/movement' do
  let(:buffer) { Amun::Buffer.new('') }
  let(:content) { status_before.gsub('[point]', '') }
  let(:point) { status_before.index('[point]') }
  let(:current_content) { buffer[0...buffer.point] + '[point]' + buffer[buffer.point..-1] }

  before do
    set_current_buffer(buffer)
    buffer << content
    buffer.point = point
  end

  describe '#backward_char' do
    before { backward_char }

    context 'point at first character of first line' do
      let(:status_before) { "[point]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit." }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit." }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at first character of a line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]consectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum dolor sit amet,[point]\nconsectetur adipiscing elit." }

      it 'moved to last character of previous line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at last character of line last line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit[point]." }

      it 'move backward one character' do
        expect(current_content).to eq status_after
      end
    end
  end

  describe '#forward_char' do
    before { forward_char }

    context 'point at first character' do
      let(:status_before) { "[point]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit." }
      let(:status_after) { "L[point]orem ipsum dolor sit amet,\nconsectetur adipiscing elit." }

      it 'moved to second character' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at last character of line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nconsectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur adipiscing elit." }

      it 'moved to first character of next line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at last character of line last line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.[point]" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end
  end

  describe '#next_line' do
    before { next_line }

    context 'point at beginning of the first line' do
      let(:status_before) { "[point]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur adipiscing elit." }

      it 'moved to beginning of the next line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of the line and both lines are equal' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nLorem ipsum dolor sit amet," }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nLorem ipsum dolor sit amet,[point]" }

      it 'moved to end of the next line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of line and first line is longer that the next one' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nconsectetur elit." }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur elit.[point]" }

      it 'moved to end of the next line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of line and first line is shorter that the next one' do
      let(:status_before) { "Lorem ipsum,[point]\nconsectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum,\nconsectetur [point]adipiscing elit." }

      it 'moved to same distance from the beggining on this line to the next one' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at empty line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]\nconsectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n\n[point]consectetur adipiscing elit." }

      it 'moved to beginning of the next line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at empty line at the end' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]" }

      it 'not change position' do
        expect(current_content).to eq status_after
      end
    end
  end

  describe '#previous_line' do
    before { previous_line }

    context 'point at beginning of the second line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]consectetur adipiscing elit." }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit." }

      it 'moved to beginning of the previous line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of the line and both lines are equal' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nLorem ipsum dolor sit amet,[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,[point]\nLorem ipsum dolor sit amet," }

      it 'moved to end of the previous line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of line and second line is longer that the previous one' do
      let(:status_before) { "Lorem ipsum,\nLorem ipsum dolor sit amet,[point]" }
      let(:status_after) { "Lorem ipsum,[point]\nLorem ipsum dolor sit amet," }

      it 'moved to end of the previous line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at end of line and second line is shorter that the previous one' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nadipiscing elit.[point]" }
      let(:status_after) { "Lorem ipsum dolo[point]r sit amet,\nadipiscing elit." }

      it 'moved to same distance from the beggining on this line to the previous one' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at empty line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]\nconsectetur adipiscing elit." }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit." }

      it 'moved to beginning of the previous line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at middle of first line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]\nconsectetur adipiscing elit." }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit." }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point beginning of first line' do
      let(:status_before) { "Lorem ipsum[point] dolor sit amet,\n\nconsectetur adipiscing elit." }
      let(:status_after) { "Lorem ipsum[point] dolor sit amet,\n\nconsectetur adipiscing elit." }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point at empty line at the end' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur\n[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur\n" }

      it 'moved to beginning of previous line' do
        expect(current_content).to eq status_after
      end
    end
  end

  describe '#beginning_of_line' do
    before { beginning_of_line }

    context 'point in beginning of first line' do
      let(:status_before) { "[point]Lorem ipsum dolor sit amet,\nconsectetur\n" }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\nconsectetur\n" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the middle of first line' do
      let(:status_before) { "Lorem ipsum [point]dolor sit amet,\nconsectetur\n" }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\nconsectetur\n" }

      it 'move to beginning of the line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the end of line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }
      let(:status_after) { "[point]Lorem ipsum dolor sit amet,\nconsectetur\n" }

      it 'move to beginning of the line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the beginning of a line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]consectetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur\n" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the middle of a line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsec[point]tetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur\n" }

      it 'move to line beginning' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the buffer end' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur\n[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur\n[point]" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the end of last buffer line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\n[point]consectetur" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end
  end

  describe '#end_of_line' do
    before { end_of_line }

    context 'point in end of first line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the middle of first line' do
      let(:status_before) { "Lorem ipsum [point]dolor sit amet,\nconsectetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }

      it 'move to end of the line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the end of line' do
      let(:status_before) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,[point]\nconsectetur\n" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the beginning of a line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\n[point]consectetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur[point]\n" }

      it 'move to end of line' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the middle of a line in the middle' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsec[point]tetur\n" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur[point]\n" }

      it 'move to line end' do
        expect(current_content).to eq status_after
      end
    end

    context 'point in the buffer end' do
      let(:status_before) { "Lorem ipsum dolor sit amet,\nconsectetur\n[point]" }
      let(:status_after) { "Lorem ipsum dolor sit amet,\nconsectetur\n[point]" }

      it 'does not move' do
        expect(current_content).to eq status_after
      end
    end
  end
end
