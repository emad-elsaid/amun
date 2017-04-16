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
        modified_character = modified_char if ch == "\e"

        return ch.to_s if modified_character.nil?
        return "#{ch} #{modified_character}" if modified_character.is_a? Numeric
        return "#{ch} #{modified_character}" if modified_character.length > 1

        begin
          eval "?\\M-#{modified_character}"
        rescue SyntaxError
          return "#{ch} #{modified_character}"
        end
      end

      private

      module_function

      def modified_char
        Curses.stdscr.timeout = TIMEOUT
        char = Curses.stdscr.get_char
        Curses.stdscr.timeout = -1
        char
      end
    end
  end
end
