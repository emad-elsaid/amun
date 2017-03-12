require 'test_helper'

class AmunTest < Minitest::Test # :nodoc:
  def test_that_it_has_a_version_number
    refute_nil ::Amun::VERSION
  end

  def test_can_get_instance
    assert Amun::Application.instance
  end
end
