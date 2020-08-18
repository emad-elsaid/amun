require_relative '../spec_helper'

describe Amun::Buffer do
  let(:name) { 'a buffer' }
  let(:io) { StringIO.new('buffer content') }
  subject { Amun::Buffer.new name, io }

  it_behaves_like 'event manager'

  it { is_expected.to respond_to :name }

  it { is_expected.to respond_to :io }
  its(:io) { is_expected.to be io }

  it { is_expected.to respond_to :major_mode }

  it { is_expected.to respond_to :minor_modes }
  its(:minor_modes) { is_expected.to be_a Set }

  describe '#point' do
    its(:point) { is_expected.to be 0 }

    context 'when set to negative' do
      before do
        subject.point = -10
      end
      its(:point) { is_expected.to be 0 }
    end

    context 'when set to a number' do
      before do
        subject.point = io.length - 5
      end
      its(:point) { is_expected.to be io.length - 5 }
    end

    context 'when set to more than the content length' do
      before do
        subject.point = io.length + 10
      end
      its(:point) { is_expected.to eq io.length }
    end
  end

  describe '#mark' do
    its(:mark) { is_expected.to be nil }

    context 'when set to negative' do
      before do
        subject.mark = -10
      end
      its(:mark) { is_expected.to be 0 }
    end

    context 'when set to a number' do
      before do
        subject.mark = io.length - 5
      end
      its(:mark) { is_expected.to be io.length - 5 }
    end

    context 'when set to more than the content length' do
      before do
        subject.mark = io.length + 10
      end
      its(:mark) { is_expected.to eq io.length }
    end
  end

  describe '#slice!' do
    let(:text) { 'a buffer string' }
    let(:io) { StringIO.new text }

    it 'deletes part of the string' do
      subject.slice! 8, 7
      expect(subject.to_s).to eq 'a buffer'
    end

    it 'deletes character at index' do
      subject.slice! 8
      expect(subject.to_s).to eq 'a bufferstring'
    end
  end

  describe '#clear' do
    it 'clears the buffer content' do
      subject.clear
      expect(subject.to_s).to be_empty
    end
  end

  context 'Class instance' do
    subject { Amun::Buffer }
    its(:instances) { is_expected.to be_a Set }
    its(:scratch) { is_expected.to be_a Amun::Buffer }
    its('scratch.name') { is_expected.to eq '*Scratch*' }
    its(:messages) { is_expected.to be_a Amun::Buffer }
    its('messages.name') { is_expected.to eq '*Messages*' }
  end
end
