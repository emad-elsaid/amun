require_relative '../../spec_helper'

describe Amun::Windows::Frame do

  before do
    Amun::EventManager.clear
  end

  it 'can can resize children' do
    expect(subject.window).to receive(:resize)
    expect(subject.echo_area).to receive(:resize)
    subject.size = Rect.new(left: 10, top: 10, width: 100, height: 100)
  end

  describe '#render' do
    context 'when window in not rendering' do
      before { subject.window = nil }

      it 'handles exceptions' do
        expect{ subject.render }.not_to raise_error
      end
    end
  end

  describe '#trigger' do
    it 'trigger window' do
      expect(subject.window).to receive(:trigger)
      subject.trigger('event')
    end

    it 'trigger echo area' do
      expect(subject.echo_area).to receive(:trigger)
      subject.trigger('event')
    end

    context 'when a mini buffer is set' do
      let(:mini_buffer) { Amun::Windows::MiniBufferWindow.new('') }
      before { subject.mini_buffer = mini_buffer }

      it 'trigger mini buffer' do
        expect(subject.mini_buffer).to receive(:trigger)
        subject.trigger('event')
      end

      it 'does not trigger the window' do
        expect(subject.window).not_to receive(:trigger)
        expect(subject.mini_buffer).to receive(:trigger)
        subject.trigger('event')
      end
    end

    context 'when window in does not trigger' do
      before { subject.window = nil }

      it 'handles exceptions' do
        expect{ subject.trigger('event') }.not_to raise_error
      end
    end
  end
end
