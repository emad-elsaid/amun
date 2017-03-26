require 'curses'

module Amun
  module Helpers
    module Keyboard
      module_function

      TIMEOUT = 100

      def char
        ch = Curses.stdscr.get_char
        Curses.stdscr.timeout = TIMEOUT
        modified_char = Curses.stdscr.get_char if ch == "\e"
        Curses.stdscr.timeout = -1

        return ch if modified_char.nil?
        return "#{ch} #{modified_char}" if modified_char.is_a? Numeric
        return "#{ch} #{modified_char}" if modified_char.size > 1

        begin
          eval "?\\M-#{modified_char}"
        rescue SyntaxError
          return "#{ch} #{modified_char}"
        end
      end
    end
  end
end
