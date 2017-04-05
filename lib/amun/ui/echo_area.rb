require 'amun/buffer'
require 'forwardable'

module Amun
  module UI
    # a line that is rendered by default at the end on the screen
    # takes the whole width of screen
    # should be linked to \*messages\* memory buffer and display new messages
    # in the buffer text
    class EchoArea
      extend Forwardable

      def_delegator :events, :trigger

      attr_writer :events

      def events
        @events ||= EventManager.new
      end

      def initialize
        @last_messages_size = 0
      end

      def height
        message.count("\n") + 1
      end

      def render(curses_window)
        curses_window.clear
        curses_window << message
        update_last_messages_size
      end

      def self.log(message)
        Buffer.messages.text << message
      end

      private

      def message
        Buffer.messages.text[@last_messages_size..-1].strip
      end

      def update_last_messages_size
        @last_messages_size = Buffer.messages.text.length
      end
    end
  end
end
