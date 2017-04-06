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
        read_io if buffer.empty?
      end

      def render(curses_window)
        curses_window.clear
        curses_window.scrollok(true)

        point = buffer.point

        curses_window << buffer[0...point]

        curses_window.attron(Helpers::Colors::REVERSE)
        at_point = buffer[point]
        curses_window << case at_point
                         when "\n"
                           " \n"
                         when nil
                           " "
                         else
                           at_point
                         end
        curses_window.attroff(Helpers::Colors::REVERSE)
        curses_window << buffer[(point + 1)..-1]
      end

      private

      attr_accessor :buffer, :events

      def read_io
        buffer << buffer.io.read
      end
    end
  end
end
