require 'amun/ui/buffer'
require 'amun/ui/mode_line'
require 'forwardable'

module Amun
  module UI
    module Windows
      # a window to display any buffer
      # or the current buffer
      class BufferWindow
        extend Forwardable

        def_delegator :buffer, :trigger

        attr_writer :mode_line

        def initialize(buffer = nil)
          @buffer = buffer
        end

        def render(window)
          major_mode_area = major_mode_window(window)
          mode_line_area = mode_line_window(window)

          buffer.major_mode.render(major_mode_area)
          mode_line.render(mode_line_area)
        ensure
          major_mode_area.close
          mode_line_area.close
        end

        def mode_line
          @mode_line ||= ModeLine.new(self)
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

        def major_mode_window(window)
          window.subwin(
            window.maxy - 1, window.maxx,
            window.begy, window.begx
          )
        end

        def mode_line_window(window)
          window.subwin(
            1, window.maxx,
            window.begy + window.maxy - 1, window.begx
          )
        end
      end
    end
  end
end
