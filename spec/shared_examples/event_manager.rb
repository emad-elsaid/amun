shared_examples 'event manager' do
  it { is_expected.to respond_to :bind }
  it { is_expected.to respond_to :unbind }
  it { is_expected.to respond_to :bind_all }
  it { is_expected.to respond_to :unbind_all }
  it { is_expected.to respond_to :trigger }

  let(:target) { double(public_method: true) }
  it 'bind events and execute it when triggered' do
    subject.bind('event', target, :public_method)
    expect(target).to receive(:public_method).with('event')
    subject.trigger('event')
  end
end
