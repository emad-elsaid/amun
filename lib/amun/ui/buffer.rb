require 'set'
require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'amun/ui/mode_line'

module Amun
  module UI
    # A buffer could present any kind of IO object (File, StringIO...etc)
    # also it has a major mode responsible of presenting data and manipulating
    # text.
    class Buffer
      attr_accessor :io, :name, :major_mode, :minor_modes, :mode_line, :point, :mark

      DEFAULT_MODE = Amun::MajorModes::Fundamental
      DEFAULT_MODE_LINE = Amun::UI::ModeLine

      def initialize(opts = {})
        self.io = opts.fetch(:io, StringIO.new)
        self.name = opts[:name].to_s
        self.major_mode = opts.fetch(:major_mode_class, DEFAULT_MODE).new(self)
        self.mode_line = DEFAULT_MODE_LINE.new(self)
        self.minor_modes = []

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
          @scratch ||= new(name: '*Scratch*')
          instances << @scratch
          @scratch
        end
      end
    end
  end
end
