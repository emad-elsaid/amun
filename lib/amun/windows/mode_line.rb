module Amun
  module Windows
    # a line of small segments that display
    # information about the current window,
    # like mode name, line number, buffer name...etc
    class ModeLine < Base
      attr_reader :left_segments, :right_segments

      def initialize(size)
        super(size)
        @right_segments = []
        @left_segments = [
          :mode_line_buffer_name,
          :mode_line_major_mode_name,
        ]

        Helpers::Colors.register_default(:mode_line, 0, 255)
      end

      def render(buffer)
        right_output = render_segments(right_segments, buffer)
        left_output = render_segments(left_segments, buffer)
        filler = empty_space(right_output, left_output)

        curses_window.erase
        Helpers::Colors.print(curses_window, *left_output, filler, *right_output)
        curses_window.refresh
      end

      private

      def empty_space(right_output, left_output)
        text_size = (right_output + left_output).map(&:size).inject(0, :+)
        empty_space = [0, width - text_size].max
        (' ' * empty_space).colorize(:mode_line)
      end

      def render_segments(segments, buffer)
        segments.map do |segment|
          send(segment, buffer)
        end.flatten
      end
    end
  end
end
