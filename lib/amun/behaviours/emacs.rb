require 'amun/buffer'
require 'curses'

module Amun
  module Behaviours
    module Emacs
      def emacs_behaviour_initialize
        emacs_movement_initialize
        emacs_erasing_initialize

        bind_all self, :insert_char
      end

      def emacs_movement_initialize
        bind "\C-f", self, :forward_char
        bind Curses::KEY_RIGHT.to_s, self, :forward_char

        bind "\C-b", self, :backward_char
        bind Curses::KEY_LEFT.to_s, self, :backward_char

        bind "\C-n", self, :next_line
        bind Curses::KEY_DOWN.to_s, self, :next_line

        bind "\C-p", self, :previous_line
        bind Curses::KEY_UP.to_s, self, :previous_line

        bind "\C-a", self, :beginning_of_line
        bind Curses::KEY_HOME.to_s, self, :beginning_of_line

        bind "\C-e", self, :end_of_line
        bind Curses::KEY_END.to_s, self, :end_of_line
      end

      def emacs_erasing_initialize
        bind "\C-d", self, :delete_char

        bind Curses::Key::BACKSPACE.to_s, self, :backward_delete_char # this doesn't work, check linux
        bind "\C-?", self, :backward_delete_char # C-? is backspace on mac terminal for some reason

        bind Curses::Key::DC.to_s, self, :forward_delete_char
        bind "\C-k", self, :kill_line
        bind "\M-d", self, :kill_word
      end

      def insert_char(char)
        return true unless char.is_a? String
        return true unless char.length == 1
        return true unless char.valid_encoding?
        return true unless char =~ /[[:print:]\n\t]/

        buffer.insert(buffer.point, char)
        buffer.point += 1

        true
      end

      def forward_char(*)
        buffer.point += 1
        true
      end

      def backward_char(*)
        buffer.point -= 1
        true
      end

      def next_line(*)
        line_begin = buffer.rindex("\n", buffer.point) || 0
        line_end = buffer.index("\n", buffer.point + 1) || buffer.length + 1
        next_line_end = buffer.index("\n", line_end + 1) || buffer.length + 1
        point_offset = buffer.point - line_begin
        buffer.point = [line_end + point_offset, next_line_end].min
        true
      end

      def previous_line(*)
        line_begin = buffer.rindex("\n", buffer.point) || 0
        previous_line_begin = buffer.rindex("\n", line_begin - 1) || 0
        point_offset = buffer.point - line_begin
        buffer.point = [previous_line_begin + point_offset, line_begin - 1].min
        true
      end

      def beginning_of_line(*)
        point = buffer.point
        return true if point.zero?
        return true if buffer[point - 1] == "\n"

        line_start = buffer.rindex("\n", point - 1)
        buffer.point = line_start.nil? ? 0 : line_start + 1
        true
      end

      def end_of_line(*)
        point = buffer.point
        return true if buffer[point] == "\n"

        line_end = buffer.index("\n", point)
        buffer.point = line_end || buffer.length
        true
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

      # TODO should move text to kill ring
      def kill_line(*)
        if buffer[buffer.point] == "\n"
          buffer.slice!(buffer.point)
          return true
        end

        line_end = buffer.index(/$/, buffer.point)
        buffer.slice!(buffer.point, line_end - buffer.point)
        true
      end

      # TODO should move text to kill ring
      def kill_word(*)
        first_non_letter = buffer.index(/\P{L}/, buffer.point) || buffer.length
        word_beginning = buffer.index(/\p{L}/, first_non_letter) || buffer.length
        buffer.slice!(buffer.point, word_beginning - buffer.point)
        true
      end

      # This should be bound to \M-BACKSPACE or \M-DEL but I think the terminal doesn't send it
      # So the implementation will remain there until we find a way to catch this key
      #
      # TODO should move text to kill ring
      def backward_kill_word(*)
        first_letter_backward = buffer.rindex(/\p{L}/, buffer.point) || 0
        first_non_letter_before_word = buffer.rindex(/\P{L}/, first_letter_backward) || -1
        buffer.slice!(first_non_letter_before_word + 1 .. buffer.point)
        true
      end
    end
  end
end
