require 'curses'
require 'amun/event_manager'
require 'amun/buffer'
require 'amun/windows/base'
require 'amun/windows/buffer_window'
require 'amun/windows/echo_area'

module Amun
  module Windows
    # a Frame fills all the space in terminal
    # renders an echo area or mini buffer if it exists
    # and an object that
    # respond to #render and #trigger, like buffer,
    # or another window or so
    class Frame < Base
      attr_accessor :mini_buffer, :window, :echo_area
      attr_writer :screen

      def initialize(size = default_size)
        super(size)
        @window = BufferWindow.new(top_window_size)
        @echo_area = EchoArea.new(bottom_window_size)
        bind(Curses::KEY_RESIZE, self, :set_size_to_terminal)
      end

      def trigger(event)
        EventManager.join(event, self.events, echo_area, mini_buffer || window, EventManager)
      rescue StandardError => error
        handle_exception(error)
      end

      def render
        render_window(window)
        render_window(bottom_area)
      end

      def set_size_to_terminal(*)
        self.size = default_size
      end

      private

      def resize
        super
        window.size = top_window_size
        echo_area.size = bottom_window_size
      end

      def bottom_area
        mini_buffer || echo_area
      end

      def default_size
        Rect.new(
          top: 0,
          left: 0,
          width: Curses.stdscr.maxx,
          height: Curses.stdscr.maxy
        )
      end

      def top_window_size
        Rect.new(
          top: top,
          left: left,
          width: width,
          height: height - 1
        )
      end

      def bottom_window_size
        Rect.new(
          top: top + height - 1,
          left: left,
          width: width,
          height: 1
        )
      end

      def render_window(window)
        window.render
        mini_buffer.render if mini_buffer
      rescue StandardError => error
        handle_exception(error)
      end

      def handle_exception(e)
        Buffer.messages << "#{e.message} (#{e.backtrace.first})\n"
      end
    end
  end
end
