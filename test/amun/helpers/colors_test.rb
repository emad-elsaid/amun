require 'test_helper'
require 'amun/helpers/colors'

module Curses # :nodoc:
  def self.color_pairs; 10 end
  def self.init_pair(i, f, b); true end
  def self.color_pair(i); true end
end

module Amun::Helpers::Colors # :nodoc:
  module_function

  def clear; COLORS.clear; end
end

class ColorsTest < Minitest::Test # :nodoc:
  def test_cant_register_color_more_than_max
    colors = Amun::Helpers::Colors
    colors.clear
    10.times { |i| colors.register("window_title_#{i}", 16, 18) }
    refute true
  rescue RuntimeError
    assert true
  end

  def test_register_color_when_pairs_are_available
    colors = Amun::Helpers::Colors
    colors.clear
    9.times { |i| colors.register("window_title_#{i}", 16, 18) }
    assert true
  end

  def test_registered_color
    colors = Amun::Helpers::Colors
    colors.clear
    colors.register(:color, 16, 18)
    assert colors.registered?(:color)
  end

  def test_not_registered_color
    colors = Amun::Helpers::Colors
    colors.clear
    refute colors.registered?(:color)
  end
end
