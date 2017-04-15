require 'amun/windows/base'

module Amun
  module Windows
    # this class renders the buffer in a curses window
    # makes sure the current character under point is highlighted
    # highlight the space between point and mark
    # and make sure to color text and other stuff
    # consider it the rendering engine of the buffer
    class TextRenderer < Base
      def render(buffer)
        curses_window.erase
        curses_window.scrollok(true)

        point = buffer.point

        curses_window << buffer[0...point]
        render_point(buffer)
        curses_window << buffer[(point + 1)..-1]

        curses_window.refresh
      end

      private

      def render_point(buffer)
        curses_window.attron(Helpers::Colors::REVERSE)
        curses_window << case buffer[buffer.point]
                         when "\n"
                           " \n"
                         when nil
                           " "
                         else
                           buffer[buffer.point]
                         end
        curses_window.attroff(Helpers::Colors::REVERSE)
      end
    end
  end
end
