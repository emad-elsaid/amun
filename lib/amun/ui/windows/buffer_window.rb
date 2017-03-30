require 'amun/ui/buffer'
require 'forwardable'

module Amun
  module UI
    module Windows
      # a window to display any buffer
      # or the current buffer
      class BufferWindow
        extend Forwardable

        def_delegators :buffer,
                       :render, :trigger

        def initialize(buffer = nil)
          @buffer = buffer
        end

        # set a specific buffer to be displayed in this window
        def display_buffer(buffer)
          @buffer = buffer
        end

        # render current buffer from the Buffer class
        def display_current_buffer
          @buffer = nil
        end

        # get current buffer that this window is rendering
        def buffer
          @buffer || Buffer.current
        end
      end
    end
  end
end
