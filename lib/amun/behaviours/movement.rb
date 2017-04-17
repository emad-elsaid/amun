module Amun
  module Behaviours
    # Movement behaviour between lines, characters and paragraphs
    # along with emacs keymap for it
    module Movement
      # attach the movement events only
      def movement_keymap_initialize
        bind "\C-f", self, :forward_char
        bind Curses::KEY_RIGHT, self, :forward_char

        bind "\C-b", self, :backward_char
        bind Curses::KEY_LEFT, self, :backward_char

        bind "\C-n", self, :next_line
        bind Curses::KEY_DOWN, self, :next_line

        bind "\C-p", self, :previous_line
        bind Curses::KEY_UP, self, :previous_line

        bind "\C-a", self, :beginning_of_line
        bind Curses::KEY_HOME, self, :beginning_of_line

        bind "\C-e", self, :end_of_line
        bind Curses::KEY_END, self, :end_of_line
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
        point = buffer.point

        line_begin = buffer.rindex(/^/, point)

        line_end = buffer.index(/$/, point)
        return true if line_end == buffer.size

        next_line_end = buffer.index(/$/, line_end + 1)
        point_offset = point - line_begin
        buffer.point = [line_end + 1 + point_offset, next_line_end].min
        true
      end

      def previous_line(*)
        point = buffer.point

        line_begin = point == buffer.size && buffer[point - 1] == "\n" ? point : buffer.rindex(/^/, point)
        return true if line_begin.zero?

        previous_line_begin = buffer.rindex(/^/, line_begin - 1)

        point_offset = point - line_begin
        buffer.point = [previous_line_begin + point_offset, line_begin - 1].min
        true
      end

      def beginning_of_line(*)
        point = buffer.point
        return true if point == buffer.size

        line_start = buffer.rindex(/^/, point)
        buffer.point = line_start <= point ? line_start : 0
        true
      end

      def end_of_line(*)
        point = buffer.point
        return true if buffer[point] == "\n"

        line_end = buffer.index("\n", point)
        buffer.point = line_end || buffer.length
        true
      end
    end
  end
end
