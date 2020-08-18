require_relative '../../spec_helper'

describe Amun::Windows::BufferWindow do
  subject { described_class.new size }

  let(:size) { Rect.new(left: 0, top: 0, width: 100, height: 100) }

  describe '#size=' do
    let(:new_size) { Rect.new(left: 10, top: 10, width: 50, height: 50) }

    it 'resizes mode line' do
      expect(subject.mode_line).to receive(:size=)
      subject.size = new_size
    end
  end
end
