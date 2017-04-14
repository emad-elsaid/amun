require_relative '../../spec_helper'

describe Amun::ModeLineSegments::BufferName do
  subject { Amun::ModeLineSegments::BufferName.new }
  let(:buffer_name) { 'buffer name' }
  let(:buffer) { Amun::Buffer.new buffer_name }

  it { is_expected.to respond_to :render }

  context '#render' do
    it 'should return a string that contains buffer name' do
      expect(subject.render(buffer)).to include buffer_name
    end
  end
end
