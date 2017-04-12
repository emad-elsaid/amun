require 'amun/windows/base'
require 'amun/helpers/colors'
require 'amun/mode_line_segments/major_mode'
require 'amun/mode_line_segments/buffer_name'

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
          ModeLineSegments::BufferName.new,
          ModeLineSegments::MajorMode.new
        ]

        Helpers::Colors.register_default(:mode_line, 0, 255)
      end

      def render(buffer)
        right_output = render_segments(right_segments, buffer)
        left_output = render_segments(left_segments, buffer)

        size = (right_output + left_output).map(&:size).inject(0, :+)
        empty_space = [0, curses_window.maxx - size].max
        filler = (' ' * empty_space).colorize(:mode_line)

        curses_window.clear
        Helpers::Colors.print(curses_window, *left_output, filler, *right_output)
        curses_window.refresh
      end

      private

      def render_segments(segments, buffer)
        segments.map do |segment|
          segment.render(buffer)
        end.flatten
      end
    end
  end
end
