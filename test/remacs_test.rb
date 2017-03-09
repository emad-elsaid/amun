require 'test_helper'

class RemacsTest < Minitest::Test
 def test_that_it_has_a_version_number
    refute_nil ::Remacs::VERSION
  end
end
