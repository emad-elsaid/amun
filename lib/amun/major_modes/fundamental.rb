require 'amun/helpers/colors'

module Amun
  module MajorModes
    # Basic mode that show any Generic IO
    class Fundamental
      def initialize(buffer)
        @buffer = buffer

        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler
      end

      def trigger(event)
        EventManager.join(event, @events)
      end

      def render(window)
        window.clear
        string = @buffer.io.string.to_s
        point = @buffer.point

        window << string[0...point]
        window.attron(Helpers::Colors::REVERSE)
        window << (string[point] || ' ')
        window.attroff(Helpers::Colors::REVERSE)
        window << string[(point + 1)..-1]
      end

      def event_handler(event)
        case event
        when /[^[:print:]\n\t]/
          true
        else
          @buffer.point += 1
          @buffer.io << event
        end
      end
    end
  end
end
