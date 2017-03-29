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

      def render(window)
        window.clear
        point = buffer.point

        window << buffer.text[0...point]

        window.attron(Helpers::Colors::REVERSE)
        at_point = buffer.text[point]
        window << (at_point == "\n" || at_point.nil? ? " \n" : at_point)
        window.attroff(Helpers::Colors::REVERSE)

        window << buffer.text[(point + 1)..-1]
      end

      private

      attr_accessor :buffer, :events

      def read_io
        buffer.text = buffer.io.read
      end
    end
  end
end
