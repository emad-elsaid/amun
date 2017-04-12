require 'amun/windows/base'
require 'amun/buffer'
require 'amun/windows/text_renderer'
require 'amun/primitives/rect'

module Amun
  module Windows
    class MiniBufferWindow < Base
      attr_reader :buffer

      def initialize(name, default_value = '', &block)
        super(default_size)

        @buffer = Buffer.new(name)
        @buffer << default_value
        @buffer.point = default_value.length
        @done_block = block if block_given?
        @text_renderer = TextRenderer.new(text_renderer_size)

        bind "\e", self, :cancel
        bind "\C-g", self, :cancel
        bind "\n", self, :done
        bind "done", self, :exec_done_block
      end

      def attach(frame)
        self.size = Rect.new(
          top: frame.top + frame.height - 1,
          left: frame.left,
          width: frame.width,
          height: 1
        )
        @frame = frame
        @frame.mini_buffer = self
      end

      def detach
        @frame.mini_buffer = nil
        @frame = nil
      end

      def attached?
        @frame && @frame.mini_buffer == self
      end

      def render
        curses_window.erase
        curses_window << buffer.name
        curses_window.refresh
        @text_renderer.render(buffer)
      end

      def trigger(event)
        EventManager.join(
          event,
          events,
          buffer
        )
      end

      def cancel(*)
        detach
        trigger("cancel")
        buffer.clear
      end

      def done(*)
        detach
        trigger("done")
        buffer.clear
      end

      def exec_done_block(*)
        return unless @done_block
        @done_block.call(self)
      end

      private

      def resize
        super
        @text_renderer.size = text_renderer_size
      end

      def text_renderer_size
        Rect.new(
          top: top,
          left: left + buffer.name.length,
          width: width - buffer.name.length,
          height: height
        )
      end

      def default_size
        Rect.new(
          top: 0,
          left: 0,
          width: Curses.stdscr.maxx,
          height: Curses.stdscr.maxy
        )
      end
    end
  end
end
