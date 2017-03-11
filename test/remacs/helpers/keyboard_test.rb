require 'test_helper'
require 'remacs/helpers/keyboard'

class KeyboardTest < Minitest::Test
  def test_returns_same_character_for_printables
    assert_equal Remacs::Helpers::Keyboard.key2event('q'), 'q'
  end

  def test_returns_ord_for_control_character
    assert_equal Remacs::Helpers::Keyboard.key2event("\C-c"), "\C-c".ord
  end
end
