require 'amun/event_manager'
require 'amun/major_modes/fundamental'
require 'amun/ui/presenters/fundamental'
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
      attr_accessor :minor_modes, :presenter, :mode_line
      attr_reader :io, :major_mode

      def initialize(
        io: StringIO.new,
        major_mode: Amun::MajorModes::Fundamental.new,
        presenter: Amun::UI::Presenters::Fundamental.new,
        mode_line: Amun::UI::ModeLine.new
      )
        self.io = io

        self.major_mode = major_mode
        self.minor_modes = []

        self.presenter = presenter
        self.mode_line = mode_line
      end

      def trigger(event)
        minor_modes.all? { |mode| mode.trigger(event) } &&
          major_mode.trigger(event)
      end

      def render(window)
        presenter.render(window) &&
          mode_line.render(window)
      end

      def major_mode=(mode)
        raise "Can't set nil mode for a buffer" if mode.nil?
        @major_mode = mode
      end

      private

      def io=(io)
        raise "Can't set nil IO for buffer" if io.nil?
        @io = io
      end
    end
  end
end
