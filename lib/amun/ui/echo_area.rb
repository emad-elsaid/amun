require 'amun/ui/buffer'

module Amun
  module UI
    # a line that is rendered by default at the end on the screen
    # takes one line height and extends to take the whole width of screen
    # should be linked to \*messages\* memory buffer and display new messages
    # in the buffer text
    class EchoArea
      attr_writer :events

      def events
        @events ||= EventManager.new
      end

      def initialize
        @last_messages_size = 0
      end

      def trigger(event)
        EventManager.join(event, events)
      end

      # render the echo area window
      def render(window)
        window.clear
        window << message
        update_last_messages_size
      end

      private

      def message
        Buffer.messages.text[@last_messages_size..-1].strip
      end

      def update_last_messages_size
        @last_messages_size = Buffer.messages.text.size
      end
    end
  end
end
