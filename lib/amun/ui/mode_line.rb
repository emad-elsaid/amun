require 'amun/helpers/colors'
require 'amun/ui/mode_line_segments/major_mode'
require 'amun/ui/mode_line_segments/buffer_name'

module Amun
  module UI
    class ModeLine
      attr_reader :left_segments, :right_segments

      def initialize
        Helpers::Colors.register_default(:mode_line, 0, 255)
        @left_segments = [
          ModeLineSegments::BufferName,
          ModeLineSegments::MajorMode
        ]
        @right_segments = []
      end

      def render(buffer, window)
        right_output = right_segments.map do |segment|
          segment.render(buffer, window)
        end.flatten

        left_output = left_segments.map do |segment|
          segment.render(buffer, window)
        end.flatten

        size = (right_output + left_output).map(&:size).inject(0, :+)
        empty_space = [0, window.maxx - size].max
        filler = (' ' * empty_space).colorize(:mode_line)

        Helpers::Colors.print(window, *left_output, filler, *right_output)
      end
    end
  end
end
