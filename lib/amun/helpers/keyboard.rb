require 'curses'

module Amun
  module Helpers
    # a module to deal with the keyboard
    # a complementary module to curses
    # doesn't intend to replace it
    # it was created to overcome the shorcoming
    # of getting a character + meta from the keyboard
    # in the first place.
    module Keyboard
      module_function

      TIMEOUT = 100

      # get a character from the keyboard
      # and make sure you detect the meta combination
      def char
        ch = Curses.stdscr.get_char
        Curses.stdscr.timeout = TIMEOUT
        modified_char = Curses.stdscr.get_char if ch == "\e"
        Curses.stdscr.timeout = -1

        return ch if modified_char.nil?
        return "#{ch} #{modified_char}" if modified_char.is_a? Numeric
        return "#{ch} #{modified_char}" if modified_char.length > 1

        begin
          eval "?\\M-#{modified_char}"
        rescue SyntaxError
          return "#{ch} #{modified_char}"
        end
      end
    end
  end
end
