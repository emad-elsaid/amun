module Amun
  module Behaviours
    # erasing, killing and deleting text from buffer and Emacs keymap for it
    module Erasing
      def erasing_keymap_initialize
        bind "\C-d", self, :delete_char

        # this doesn't work, check linux
        bind Curses::Key::BACKSPACE, self, :backward_delete_char
        # C-? is backspace on mac terminal for some reason
        bind "\C-?", self, :backward_delete_char

        bind Curses::Key::DC, self, :forward_delete_char
        bind "\C-k", self, :kill_line
        bind "\M-d", self, :kill_word
      end

      def delete_char(*)
        buffer.slice!(buffer.point)
        true
      end

      def backward_delete_char(*)
        return true if buffer.point.zero?

        buffer.point -= 1
        buffer.slice!(buffer.point)
        true
      end

      def forward_delete_char(*)
        delete_char
      end

      # TODO: should move text to kill ring
      def kill_line(*)
        if buffer[buffer.point] == "\n"
          buffer.slice!(buffer.point)
          return true
        end

        line_end = buffer.index(/$/, buffer.point)
        buffer.slice!(buffer.point, line_end - buffer.point)
        true
      end

      # TODO: should move text to kill ring
      def kill_word(*)
        first_non_letter = buffer.index(/\P{L}/, buffer.point) || buffer.length
        word_beginning = buffer.index(/\p{L}/, first_non_letter) || buffer.length
        buffer.slice!(buffer.point, word_beginning - buffer.point)
        true
      end

      # This should be bound to \M-BACKSPACE or \M-DEL but I think the terminal doesn't send it
      # So the implementation will remain there until we find a way to catch this key
      #
      # TODO: should move text to kill ring
      def backward_kill_word(*)
        first_letter_backward = buffer.rindex(/\p{L}/, buffer.point) || 0
        first_non_letter_before_word = buffer.rindex(/\P{L}/, first_letter_backward) || -1
        buffer.slice!(first_non_letter_before_word + 1..buffer.point)
        true
      end
    end
  end
end
