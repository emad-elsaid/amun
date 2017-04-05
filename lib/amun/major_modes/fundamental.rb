require 'forwardable'
require 'amun/helpers/colors'
require 'amun/behaviours/emacs'

module Amun
  module MajorModes
    # Basic mode with emacs defaults
    class Fundamental
      extend Forwardable
      include Behaviours::Emacs

      def_delegator :events, :trigger

      def initialize(buffer)
        self.buffer = buffer
        self.events = EventManager.new

        emacs_behaviour_initialize(@events)
        read_io if buffer.text.nil?
      end

      def render(curses_window)
        curses_window.clear
        curses_window.scrollok(true)

        point = buffer.point

        curses_window << buffer.text[0...point]

        curses_window.attron(Helpers::Colors::REVERSE)
        at_point = buffer.text[point]
        curses_window << (at_point == "\n" || at_point.nil? ? " \n" : at_point)
        curses_window.attroff(Helpers::Colors::REVERSE)

        curses_window << buffer.text[(point + 1)..-1]
      end

      private

      attr_accessor :buffer, :events

      def read_io
        buffer.text = buffer.io.read
      end
    end
  end
end
