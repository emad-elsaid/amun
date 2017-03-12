require 'curses'

module Amun
  module UI
    # a line that is rendered by default at the end on the screen
    # takes one line height and extends to take the whole width of screen
    # should be linked to \*messages\* memory buffer and each time the #log
    # is called it will display the message next time #render is called
    class EchoArea
      def initialize
        @window = Curses::Window.new(1, Curses.cols, Curses.lines - 1, 0)
      end

      # display a *message* in the echo area
      def echo(message)
        @window << message
      end

      # render the echo area window
      def refresh
        @window.noutrefresh
        @window.clear
      end
    end
  end
end
