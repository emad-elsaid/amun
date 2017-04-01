require 'set'
require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'amun/ui/mode_line'

module Amun
  module UI
    # A buffer could present any kind of IO object (File, StringIO...etc)
    # also it has a major mode responsible update lines and visual lines
    class Buffer
      attr_accessor :name, :io, :text
      attr_writer :major_mode, :events, :minor_modes, :mode_line, :point, :mark

      def initialize(name, io = StringIO.new)
        self.io = io
        self.name = name
        self.point = 0
      end

      def events
        @events ||= EventManager.new
      end

      def major_mode
        @major_mode ||= MajorModes::Fundamental.new(self)
      end

      def mode_line
        @mode_line ||= ModeLine.new(self)
      end

      def minor_modes
        @minor_modes ||= Set.new
      end

      def point
        return 0 if @point < 0
        max = text.size
        return max if @point > max
        @point
      end

      def mark
        return 0 if @mark < 0
        max = text.size
        return max if @mark > max
        @mark
      end

      def trigger(event)
        EventManager.join(
          event,
          *([events] + minor_modes.to_a + [major_mode])
        )
      end

      def render(window)
        major_mode_window = window.subwin(
          window.maxy - 1, window.maxx,
          window.begy, window.begx
        )
        mode_line_window = window.subwin(
          1, window.maxx,
          window.begy + window.maxy - 1, window.begx
        )

        major_mode.render(major_mode_window)
        mode_line.render(mode_line_window)
      ensure
        major_mode_window.close
        mode_line_window.close
      end

      class << self
        attr_writer :current, :instances

        def instances
          @instances ||= Set.new
        end

        def current
          @current ||= scratch
        end

        def scratch
          @scratch ||= new('*Scratch*')
          instances << @scratch
          @scratch
        end

        def messages
          @messages ||= new('*Messages*')
          instances << @messages
          @messages.text = '' if @messages.text.nil?
          @messages
        end
      end
    end
  end
end
