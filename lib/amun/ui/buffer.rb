require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'amun/ui/mode_line'

module Amun
  module UI
    # A buffer could present any kind of IO object (File, StringIO...etc)
    # also it has a major mode responsible of presenting data and manipulating
    # text.
    class Buffer
      attr_accessor :minor_modes, :mode_line, :point, :mark
      attr_reader :io, :major_mode

      def initialize(io: StringIO.new, major_mode_class: Amun::MajorModes::Fundamental)
        @io = io

        self.major_mode = major_mode_class.new(@io)
        self.minor_modes = []

        self.mode_line = Amun::UI::ModeLine.new

        self.point = 0
        self.mark = 0
      end

      def trigger(event)
        minor_modes.all? { |mode| mode.trigger(event) } &&
          major_mode.trigger(event)
      end

      def render(window)
        major_mode_window = window.subwin(window.maxy - 1, window.maxx, 0, 0)
        mode_line_window = window.subwin(1, window.maxx, window.maxy - 1, 0)

        major_mode.render(major_mode_window) &&
          mode_line.render(self, mode_line_window)
      ensure
        major_mode_window.close
        mode_line_window.close
      end

      def major_mode=(mode)
        raise "Can't set nil mode for a buffer" if mode.nil?
        @major_mode = mode
      end
    end
  end
end
