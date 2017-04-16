require 'amun/behaviours/movement'
require 'amun/behaviours/erasing'
require 'amun/behaviours/insertion'
require 'curses'

module Amun
  module Behaviours
    # Emacs default behaviour module
    # should be included in the mode
    # which needs this behaviour as part of it
    module Emacs
      include Movement
      include Erasing
      include Insertion

      def emacs_behaviour_initialize
        movement_keymap_initialize
        erasing_keymap_initialize
        insertion_keymap_initialize
      end
    end
  end
end
