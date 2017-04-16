require_relative '../../spec_helper'

describe Amun::Helpers::Keyboard do
  describe '#char' do
    let(:input) { ['k'] }

    before do
      allow(Curses.stdscr).to receive(:get_char).and_return(*input)
    end

    context 'when non-escaped character' do
      its(:char) { is_expected.to eq 'k' }
    end

    context 'when a number' do
      let(:input) { [200] }
      its(:char) { is_expected.to eq '200' }
    end

    context 'when escape is passed' do
      context 'followed by nil' do
        let(:input) { ["\e", nil] }
        its(:char) { is_expected.to eq "\e" }
      end

      context 'followed by number character' do
        let(:input) { ["\e", 230] }
        its(:char) { is_expected.to eq "\e 230" }
      end

      context 'followed by non-keyboard character' do
        let(:input) { ["\e", "resize"] }
        its(:char) { is_expected.to eq "\e resize" }
      end

      context 'followed by valid character' do
        let(:input) { ["\e", "x"] }
        its(:char) { is_expected.to eq "\M-x" }
      end

      context 'followed by another meta' do
        let(:input) { ["\e", "\M-x"] }
        its(:char) { is_expected.to eq "\e \M-x" }
      end
    end
  end
end
