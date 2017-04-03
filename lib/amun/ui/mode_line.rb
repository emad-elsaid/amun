require 'amun/helpers/colors'
require 'amun/ui/mode_line_segments/major_mode'
require 'amun/ui/mode_line_segments/buffer_name'

module Amun
  module UI
    # a line of small segments that display
    # information about the current window,
    # like mode name, line number, buffer name...etc
    class ModeLine
      attr_reader :left_segments, :right_segments

      def initialize(window)
        @window = window
        @right_segments = []
        @left_segments = [
          ModeLineSegments::BufferName.new(window),
          ModeLineSegments::MajorMode.new(window)
        ]

        Helpers::Colors.register_default(:mode_line, 0, 255)
      end

      def render(window)
        right_output = render_segments(right_segments, window)
        left_output = render_segments(left_segments, window)

        size = (right_output + left_output).map(&:size).inject(0, :+)
        empty_space = [0, window.maxx - size].max
        filler = (' ' * empty_space).colorize(:mode_line)

        Helpers::Colors.print(window, *left_output, filler, *right_output)
      end

      private

      def render_segments(segments, window)
        segments.map do |segment|
          segment.render(window)
        end.flatten
      end
    end
  end
end
