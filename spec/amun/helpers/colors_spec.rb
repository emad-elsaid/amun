require_relative '../../spec_helper'

describe Amun::Helpers::Colors do
  let(:max_colors) { 3 }
  let(:color1) { { fg: 1, bg: 2 } }
  let(:color2) { { fg: 3, bg: 4 } }

  after do
    Amun::Helpers::Colors.const_get(:COLORS).clear
  end

  before do
    allow(Curses).to receive(:color_pairs).and_return(max_colors)
  end

  describe '#register' do
    it { is_expected.to respond_to :register }

    it 'register color' do
      expect(Curses).to receive(:init_pair).with(1, color1[:fg], color1[:bg])
      subject.register(:color1, color1[:fg], color1[:bg])
    end

    it 'overwrite the same color when using same name' do
      expect(Curses).to receive(:init_pair).twice.with(1, color1[:fg], color1[:bg])

      subject.register(:color1, color1[:fg], color1[:bg])
      subject.register(:color1, color1[:fg], color1[:bg])
    end

    it 'uses different color number for different names' do
      expect(Curses).to receive(:init_pair).once.with(1, color1[:fg], color1[:bg])
      expect(Curses).to receive(:init_pair).once.with(2, color2[:fg], color2[:bg])

      subject.register(:color1, color1[:fg], color1[:bg])
      subject.register(:color2, color2[:fg], color2[:bg])
    end

    context 'when reaching maximum' do
      let(:max_colors) { 1 }

      it 'raise an error if tried to register colors over max' do
        expect { subject.register(:color1, color1[:fg], color1[:bg]) }.to raise_error Amun::Helpers::ColorLimitExceeded
      end
    end
  end

  describe '#registered?' do
    let(:registered_color) { { fg: 1, bg: 2 } }
    let(:not_registered_color) { { fg: 3, bg: 4 } }

    before do
      allow(Curses).to receive(:init_pair)
      subject.register :registered_color, registered_color[:fg], registered_color[:bg]
    end

    it { is_expected.to respond_to :registered? }

    it 'returns true for registered color' do
      expect(subject.registered?(:registered_color)).to be true
    end

    it 'returns false for not registered color' do
      expect(subject.registered?(:not_registered_color)).to be false
    end
  end

  describe '#register_default' do
    it { is_expected.to respond_to :register_default }

    it 'register the color once' do
      expect(Curses).to receive(:init_pair).once.with(1, color1[:fg], color1[:bg])

      subject.register_default(:color1, color1[:fg], color1[:bg])
      subject.register_default(:color1, color1[:fg], color1[:bg])
    end
  end

  describe '#use' do
    let(:window) { instance_double('Curses::Window') }
    it { is_expected.to respond_to :use }

    it 'changes window attributes' do
      allow(Curses).to receive(:color_pair)
      expect(window).to receive(:attron)
      subject.use(window, :color1)
    end
  end

  describe '#print' do
    let(:window) { instance_double('Curses::Window') }
    let(:string) { 'string to output' }

    it { is_expected.to respond_to :print }

    it 'send strings to the window' do
      allow(Curses).to receive(:color_pair)
      allow(subject).to receive(:use)
      expect(window).to receive(:<<).with(string)
      subject.print(window, string)
    end
  end
end

describe String do
  subject { "string to output" }

  let(:style) { Amun::Helpers::Colors::REVERSE }
  let(:color) { :black }

  it { is_expected.to respond_to :colorize }
  it { is_expected.to respond_to :color }
  it { is_expected.to respond_to :style }

  it 'changes string color' do
    expect { subject.colorize(color) }.to change { subject.color }.to color
  end

  it 'changes string style' do
    expect { subject.colorize(color, style) }.to change { subject.style }.to style
  end
end
