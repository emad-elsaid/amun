module Amun
  module MajorModes
    # basic mode that show any IO as generic text without coloring
    class Fundamental
      def initialize
        @events = Amun::EventManager.new
        @events.bind_all self, :event_handler
      end

      def trigger(event)
        @events.trigger event
      end

      def io
        @io ||= Amun::Application.instance.buffers.find do |b|
          b.major_mode == self
        end.io
      end

      def event_handler(event)
        return true if event.is_a?(Numeric) || event.size > 1
        io << event
      end
    end
  end
end
