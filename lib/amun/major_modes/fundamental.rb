require 'amun/helpers/colors'

module Amun
  module MajorModes
    # Basic mode that show any Generic IO
    class Fundamental
      def initialize(io)
        @io = io

        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler
      end

      def buffer
        @buffer ||= Amun::Application.instance.buffers.find do |b|
          b.major_mode == self
        end
      end

      def trigger(event)
        @events.trigger event
      end

      def render(window)
        window.clear
        string = @io.string.to_s
        point = buffer.point

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
          buffer.point += 1
          @io << event
        end
      end
    end
  end
end
