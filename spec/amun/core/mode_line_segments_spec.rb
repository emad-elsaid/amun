require_relative '../../spec_helper'

describe 'amin/mode_line_segments' do
  let(:buffer_name) { 'buffer name' }
  let(:buffer) { Amun::Buffer.new buffer_name }

  context 'mode_line_buffer_name' do
    it 'should return a string that contains buffer name' do
      expect(mode_line_buffer_name(buffer)).to include buffer_name
    end
  end

  context 'mode_line_major_mode_name' do
    let(:mode) { Amun::MajorModes::Fundamental.new }

    before do
      buffer.major_mode = mode
    end

    it 'should return a string that contains major mode name' do
      expect(mode_line_major_mode_name(buffer)).to include 'Fundamental'
    end
  end

end
