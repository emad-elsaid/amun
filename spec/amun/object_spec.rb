require_relative '../spec_helper'

describe Amun::Object do
  subject { Amun::Object.new }
  it_behaves_like 'event manager'
end
