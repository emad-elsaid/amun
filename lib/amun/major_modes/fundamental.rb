require 'amun/helpers/colors'
require 'amun/behaviours/emacs'

module Amun
  module MajorModes
    # Basic mode that show any IO
    class Fundamental
      include Behaviours::Emacs

      def initialize(buffer)
        @buffer = buffer

        @events = EventManager.new

        emacs_behaviour_initialize(@events)

        read_io if buffer.text.nil?
      end

      def trigger(event)
        EventManager.join(event, @events)
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

      attr_accessor :buffer

      def read_io
        buffer.text = buffer.io.read
      end
    end
  end
end
