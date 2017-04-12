require 'amun/buffer'
require 'amun/windows/base'
require 'amun/windows/text_renderer'
require 'amun/windows/mode_line'
require 'amun/primitives/rect'
require 'forwardable'

module Amun
  module Windows
    # a window to display any buffer
    # or the current buffer
    class BufferWindow < Base
      extend Forwardable

      def_delegator :buffer, :trigger

      attr_accessor :mode_line

      def initialize(size, buffer = nil)
        super(size)
        @buffer = buffer
        @mode_line = ModeLine.new(mode_line_size, self)
        @text_renderer = TextRenderer.new(text_renderer_size)
      end

      def render
        @text_renderer.render(buffer)
        @mode_line.render
      end

      # set a specific buffer to be displayed in this window
      def display_buffer(buffer)
        @buffer = buffer
      end

      # render current buffer from the Buffer class
      def display_current_buffer
        @buffer = nil
      end

      # get current buffer that this window is rendering
      def buffer
        @buffer || Buffer.current
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
          width: left,
          height: 1
        )
      end
    end
  end
end
