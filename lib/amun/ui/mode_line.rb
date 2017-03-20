require 'amun/helpers/colors'
require 'amun/ui/mode_line_segments/major_mode'
require 'amun/ui/mode_line_segments/buffer_name'

module Amun
  module UI
    class ModeLine
      attr_reader :left_segments, :right_segments

      def initialize(buffer)
        @buffer = buffer
        @right_segments = []
        @left_segments = [
          ModeLineSegments::BufferName.new(buffer),
          ModeLineSegments::MajorMode.new(buffer)
        ]

        Helpers::Colors.register_default(:mode_line, 0, 255)
      end

      def render(window)
        right_output = right_segments.map do |segment|
          segment.render(window)
        end.flatten

        left_output = left_segments.map do |segment|
          segment.render(window)
        end.flatten

        size = (right_output + left_output).map(&:size).inject(0, :+)
        empty_space = [0, window.maxx - size].max
        filler = (' ' * empty_space).colorize(:mode_line)

        Helpers::Colors.print(window, *left_output, filler, *right_output)
      end
    end
  end
end
