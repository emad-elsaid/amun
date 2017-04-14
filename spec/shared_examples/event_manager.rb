shared_examples 'event manager' do
  it { is_expected.to respond_to :bind }
  it { is_expected.to respond_to :unbind }
  it { is_expected.to respond_to :bind_all }
  it { is_expected.to respond_to :unbind_all }
  it { is_expected.to respond_to :trigger }
end
