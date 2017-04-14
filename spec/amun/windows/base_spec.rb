require_relative '../../spec_helper'

describe Amun::Windows::Base do
  let(:size) { Rect.new(left: 0, top: 0, width: 100, height: 100) }
  subject { Amun::Windows::Base.new(size) }

  it_behaves_like 'event manager'
  its(:size) { is_expected.to be size }

  context 'when setting new size' do
    let(:new_size) { Rect.new(left: 10, top: 10, width: 1000, height: 1000) }
    let(:curses_window) { subject.send :curses_window }

    it "should call curses resize and move" do
      expect(curses_window).to receive(:resize)
      expect(curses_window).to receive(:move)
      subject.size = new_size
    end
  end
end
