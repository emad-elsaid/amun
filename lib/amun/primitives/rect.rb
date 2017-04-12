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
