require_relative '../../spec_helper'

describe Amun::ModeLineSegments::MajorMode do
  subject { Amun::ModeLineSegments::MajorMode.new }
  let(:buffer_name) { 'buffer name' }
  let(:buffer) { Amun::Buffer.new buffer_name }

  it { is_expected.to respond_to :render }

  context '#render' do
    it 'should return a string that contains major mode name' do
      expect(subject.render(buffer)).to include 'Fundamental'
    end
  end
end
