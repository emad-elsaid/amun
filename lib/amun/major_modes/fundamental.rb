require 'amun/helpers/colors'
require 'amun/behaviours/emacs'

module Amun
  module MajorModes
    # Basic mode that show any IO
    class Fundamental
      include Amun::Behaviours::Emacs

      def initialize(buffer)
        @buffer = buffer

        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler
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

      def event_handler(event)
        return true unless event.is_a? String
        return true unless event.length == 1
        return true unless event.valid_encoding?

        case event
        when /[^[:print:]\n\t]/
          true
        else
          buffer.text.insert(buffer.point, event)
          buffer.point += 1
        end
      end

      private

      attr_accessor :buffer

      def read_io
        buffer.text = buffer.io.read
      end
    end
  end
end
