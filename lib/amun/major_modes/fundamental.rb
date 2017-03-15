require 'amun/helpers/colors'

module Amun
  module MajorModes
    # basic mode that show any IO as generic text without coloring
    class Fundamental
      def initialize(io)
        @io = io

        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler
      end

      def buffer
        @buffer ||= Amun::Application.instance.buffers.find { |b| b.major_mode == self }
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
        window << ( string[point] || ' ' )
        window.attroff(Helpers::Colors::REVERSE)
        window << string[(point + 1)..-1]
      end

      def event_handler(event)
        return true if event =~ /[^[:print:]\n\t]/
        buffer.point += 1
        @io << event
      end
    end
  end
end
