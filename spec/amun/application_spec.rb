require_relative '../spec_helper'

describe Amun::Application do
  subject { Amun::Application }

  describe '#run' do
    let(:thread) { double(Thread) }

    before do
      class_double(Thread)
      allow(thread).to receive :join
    end

    it { is_expected.to respond_to :run }
    it 'creates a thread' do
      expect(Thread).to receive(:new).and_return thread
      subject.run
    end
  end
end
