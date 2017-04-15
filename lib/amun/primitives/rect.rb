# a primitive class that incapsulate
# a rectangle on screen, with position
# (top, left) and size (width, height)
class Rect
  attr_reader :top, :left, :width, :height

  # create a rectangle with top, left, width and height
  # opts(Hash):: a hash with keys (top, left, width, height)
  def initialize(opts = {})
    @top = opts[:top]
    @left = opts[:left]
    @width = opts[:width]
    @height = opts[:height]
  end
end
