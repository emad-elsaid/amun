require 'amun/helpers/colors'

module Amun
  module MajorModes
    # Basic mode that show any Generic IO
    class Fundamental
      def initialize(buffer)
        @buffer = buffer

        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler

        read_io if buffer.text.nil?
      end

      def trigger(event)
        EventManager.join(event, @events)
      end

      def render(window)
        window.clear
        point = @buffer.point

        window << @buffer.text[0...point]
        window.attron(Helpers::Colors::REVERSE)
        window << (@buffer.text[point] || ' ')
        window.attroff(Helpers::Colors::REVERSE)
        window << @buffer.text[(point + 1)..-1]
      end

      def event_handler(event)
        case event
        when /[^[:print:]\n\t]/
          true
        else
          @buffer.point += 1
          @buffer.text << event
        end
      end

      private

      def read_io
        @buffer.text = @buffer.io.read
      end
    end
  end
end
