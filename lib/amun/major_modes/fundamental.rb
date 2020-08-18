require 'amun/object'
require 'amun/helpers/colors'


module Amun
  module MajorModes
    # Basic mode with emacs defaults
    class Fundamental < Object
      def initialize
        super()

        bind "\C-d", nil, :delete_char

        # this doesn't work, check linux
        bind Curses::Key::BACKSPACE, nil, :backward_delete_char
        # C-? is backspace on mac terminal for some reason
        bind "\C-?", nil, :backward_delete_char

        bind Curses::Key::DC, nil, :forward_delete_char
        bind "\C-k", nil, :kill_line
        bind "\M-d", nil, :kill_word

        bind_all nil, :insert_char

        bind "\C-f", nil, :forward_char
        bind Curses::KEY_RIGHT, nil, :forward_char

        bind "\C-b", nil, :backward_char
        bind Curses::KEY_LEFT, nil, :backward_char

        bind "\C-n", nil, :next_line
        bind Curses::KEY_DOWN, nil, :next_line

        bind "\C-p", nil, :previous_line
        bind Curses::KEY_UP, nil, :previous_line

        bind "\C-a", nil, :beginning_of_line
        bind Curses::KEY_HOME, nil, :beginning_of_line

        bind "\C-e", nil, :end_of_line
        bind Curses::KEY_END, nil, :end_of_line
      end
    end
  end
end
