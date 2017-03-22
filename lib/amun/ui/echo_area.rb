require 'curses'

module Amun
  module UI
    # a line that is rendered by default at the end on the screen
    # takes one line height and extends to take the whole width of screen
    # should be linked to \*messages\* memory buffer and each time the #log
    # is called it will display the message next time #render is called
    class EchoArea
      attr_writer :events

      def events
        @events ||= Amun::EventManager.new
      end

      def initialize
        @message = ''
      end

      # display a *message* in the echo area
      def echo(message)
        @message = message
      end

      def trigger(event)
        EventManager.join(event, events)
      end

      # render the echo area window
      def render(window)
        window.clear
        window << @message
        @message = ''
      end
    end
  end
end
