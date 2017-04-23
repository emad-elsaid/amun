require_relative '../../spec_helper'

describe Amun::Windows::BufferWindow do
  subject { described_class.new size }

  let(:size) { Rect.new(left: 0, top: 0, width: 100, height: 100) }

  describe '#display_buffer' do
    let(:buffer) { double }

    it 'changes the buffer' do
      expect { subject.display_buffer(buffer) }.to change{ subject.buffer }.to buffer
    end
  end

  describe '#display_current_buffer' do
    subject { described_class.new size, old_buffer }
    let(:old_buffer) { double }
    let(:current_buffer) { double }

    before { allow(Amun::Buffer).to receive(:current).and_return(current_buffer) }

    it 'changes the buffer to Buffer.current' do
      expect { subject.display_current_buffer }.to change{ subject.buffer }.from(old_buffer).to current_buffer
    end
  end

  describe '#size=' do
    let(:new_size) { Rect.new(left: 10, top: 10, width: 50, height: 50) }

    it 'resizes mode line' do
      expect(subject.mode_line).to receive(:size=)
      subject.size = new_size
    end
  end
end
