require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'amun/ui/mode_line'

module Amun
  module UI
    # a buffer holds data and events attached to it for both
    # keyboard and other events, when an application wide event
    # is triggered it will be sent first to the active Buffer and
    # if nothing returned false it will bubble up to the application
    # events manager
    #
    # a buffer could present any kind of IO object (File, StringIO...etc)
    # also it has a major mode responsible of presenting data and manipulating
    # text.
    class Buffer
      attr_accessor :minor_modes, :mode_line, :point, :mark
      attr_reader :io, :major_mode

      def initialize(
        io: StringIO.new,
        major_mode: Amun::MajorModes::Fundamental.new,
        mode_line: Amun::UI::ModeLine.new
      )
        @io = io

        self.major_mode = major_mode
        self.minor_modes = []

        self.mode_line = mode_line

        self.point = 0
        self.mark = nil
      end

      def trigger(event)
        minor_modes.all? { |mode| mode.trigger(event) } &&
          major_mode.trigger(event)
      end

      def render(window)
        major_mode_window = window.subwin(window.maxy - 1, window.maxx, 0, 0)
        mode_line_window = window.subwin(1, window.maxx, window.maxy - 1, 0)

        major_mode.render(major_mode_window) &&
          mode_line.render(mode_line_window)

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
