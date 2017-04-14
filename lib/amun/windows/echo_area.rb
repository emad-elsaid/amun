require 'amun/windows/base'
require 'amun/buffer'

module Amun
  module Windows
    # a line that is rendered by default at the end on the screen
    # takes the whole width of screen
    # should be linked to \*messages\* memory buffer and display new messages
    # in the buffer text
    class EchoArea < Base
      def initialize(size)
        super(size)
        @last_messages_size = 0
      end

      def render
        curses_window.erase
        curses_window << message
        curses_window.refresh
        update_last_messages_size
      end

      private

      def message
        Buffer.messages[@last_messages_size..-1].strip.lines.last
      end

      def update_last_messages_size
        @last_messages_size = Buffer.messages.length
      end
    end
  end
end
