require_relative '../spec_helper'

describe Amun::EventManager do
  context 'instance methods' do
    subject { Amun::EventManager.new }
    it_behaves_like 'event manager'
  end

  context 'class methods' do
    subject { Amun::EventManager }
    it_behaves_like 'event manager'
  end
end
