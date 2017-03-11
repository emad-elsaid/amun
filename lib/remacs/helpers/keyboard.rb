module Remacs
  module Helpers
    # Keyboard has some methods to help deal with keyboard input
    module Keyboard
      module_function

      # converts a key to a value that could be used with EventManager as an event
      # the value produced is compatible with Curses library +getch+ values, so
      # if you provided an ascii character as key this method will return it as it,
      # but will convert control keys to the Curses integer value, the same value
      # that will be triggered when that key combination is presses
      #
      # key(character): ascii character or control character that should be adapted to Curses input values
      def key2event(key)
        return key unless key =~ /[^[:print:]]/
        key.ord
      end
    end
  end
end
