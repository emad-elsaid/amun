require 'amun/ui/buffer'

module Amun
  module UI
    module Windows
      # a window to display any buffer
      # or the current buffer
      class BufferWindow
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

        # render buffer
        def render(window)
          buffer.render(window)
        end

        # trigger the event in buffer
        def trigger(event)
          buffer.trigger(event)
        end
      end
    end
  end
end
