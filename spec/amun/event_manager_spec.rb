require_relative '../spec_helper'

describe Amun::EventManager do
  let(:event) { 'key_x key_y' }
  let(:target) { double(public_method: true) }

  context 'instance methods' do
    subject { Amun::EventManager.new }
    it_behaves_like 'event manager'

    describe '#bind' do
      it 'will execute method on trigger if bound' do
        subject.bind(event, target, :public_method)
        expect(target).to receive(:public_method)
        subject.trigger(event)
      end

      it 'raise error if method does not exists' do
        expect { subject.bind(:event, target, :undefined_method) }.to raise_error ArgumentError
      end
    end

    describe '#unbind' do
      before do
        subject.bind(event, target, :public_method)
      end

      it 'does not execute method when unbound' do
        subject.unbind(event, target, :public_method)
        expect(target).not_to receive(:public_method)
        subject.trigger(event)
      end

      context 'when 2 events with same prefix event' do
        let(:event2) { 'key_x key_z' }

        before do
          subject.bind(event2, target, :public_method)
          subject.unbind(event2, target, :public_method)
        end

        it 'should execute the target method when unbind the second' do
          expect(target).to receive(:public_method).once.with(event)
          subject.trigger(event)
          subject.trigger(event2)
        end
      end
    end

    describe '#bind_all' do
      it 'will execute method on triggering any event' do
        subject.bind_all(target, :public_method)
        expect(target).to receive(:public_method)
        subject.trigger(event)
      end
    end

    describe '#unbind_all' do
      before do
        subject.bind_all(target, :public_method)
      end

      it 'does not execute method when unbound with unbind_all' do
        subject.unbind_all(target, :public_method)
        expect(target).not_to receive(:public_method)
        subject.trigger(event)
      end
    end
  end

  context 'class methods' do
    subject { Amun::EventManager }
    it_behaves_like 'event manager'

    describe '#join' do
      let(:manager) { subject.new }

      context 'when having a chained events' do
        let(:event) { "\C-x \C-c" }
        let(:first_event) { "\C-x" }
        let(:second_event) { "\C-c" }

        before do
          manager.bind event, target, :public_method
        end

        it 'should return CHAINED when executing first part' do
          expect(subject.join(first_event, manager)).to be subject::CHAINED
        end

        it 'should not chain if executed the second part' do
          expect(subject.join(second_event, manager)).to be subject::CONTINUE
        end

        it 'should return intrrupted if pne method returned false' do
          allow(target).to receive(:public_method).and_return false
          expect(subject.join(event, manager)).to be subject::INTERRUPTED
        end
      end
    end
  end
end
