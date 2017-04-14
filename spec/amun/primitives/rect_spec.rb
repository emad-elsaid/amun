require_relative '../../spec_helper'

describe Rect do
  let(:left) { rand 100 }
  let(:top) { rand 100 }
  let(:width) { rand 100 }
  let(:height) { rand 100 }
  subject { Rect.new(left: left, top: top, width: width, height: height) }

  it { is_expected.to respond_to(:left) }
  it { is_expected.to respond_to(:top) }
  it { is_expected.to respond_to(:width) }
  it { is_expected.to respond_to(:height) }

  its(:left) { is_expected.to eq left }
  its(:top) { is_expected.to eq top }
  its(:width) { is_expected.to eq width }
  its(:height) { is_expected.to eq height }
end
