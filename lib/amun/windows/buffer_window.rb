require 'forwardable'

module Amun
  module Windows
    # a window to display any buffer
    # or the current buffer
    class BufferWindow < Base
      extend Forwardable

      attr_accessor :buffer
      def_delegator :buffer, :trigger

      attr_accessor :mode_line

      def initialize(size, buffer = nil)
        super(size)
        @buffer = buffer
        @mode_line = ModeLine.new(mode_line_size)
        @text_renderer = TextRenderer.new(text_renderer_size)
      end

      def render
        @text_renderer.render(buffer)
        @mode_line.render(buffer)
      end

      private

      def resize
        super
        @mode_line.size = mode_line_size
        @text_renderer.size = text_renderer_size
      end

      def text_renderer_size
        Rect.new(
          top: top,
          left: left,
          width: width,
          height: height - 1
        )
      end

      def mode_line_size
        Rect.new(
          top: top + height - 1,
          left: left,
          width: width,
          height: 1
        )
      end
    end
  end
end
