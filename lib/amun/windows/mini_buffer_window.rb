require 'amun/windows/base'
require 'amun/buffer'
require 'amun/windows/text_renderer'
require 'amun/primitives/rect'

module Amun
  module Windows
    # a minibuffer that when attached will replace the frame
    # echo area and display one line with a label (buffer name)
    # and the value typed by the user (buffer content)
    # it will fire 2 events, done and cancel, you can listen
    # on them to do stuff with the input data,
    # also after both events the buffer will be cleared
    # to allow you to reattach the same window again and reuse it,
    # also it allow passing a block to the initializer to execute it
    # when the user press enter (done event) so you can have a fast usage as such
    #    MiniBufferWindow.new("Are you sure?[Y/N]", "Y") do |window|
    #        exit if window.buffer.to_s.downcase == 'y'
    #    end.attach(Amun::Application.frame)
    # that will create a minibuffer and attach it to current active frame
    # also will have a label asking the user "Are you sure?" and a default
    # value "Y" so user can just press enter, or clear it and press any other character
    # when user press enter the block will be executed with the window itself as a parameter
    # so the block will exit amun if the answer to the question is "y"
    class MiniBufferWindow < Base
      attr_reader :buffer

      def initialize(name, default_value = '', &block)
        super(default_size)

        @buffer = Buffer.new(name)
        @buffer << default_value
        @buffer.point = default_value.length
        @done_block = block if block_given?
        @text_renderer = TextRenderer.new(text_renderer_size)

        bind "\e", self, :cancel
        bind "\C-g", self, :cancel
        bind "\n", self, :done
        bind "done", self, :exec_done_block
      end

      # attach the mini buffer to a frame of your choice,
      # that will make it replace the echo are in this frame
      def attach(frame)
        detach if attached?
        self.size = Rect.new(
          top: frame.top + frame.height - 1,
          left: frame.left,
          width: frame.width,
          height: 1
        )
        @frame = frame
        @frame.mini_buffer = self
      end

      # deatach the mini buffer from its frame
      def detach
        @frame.mini_buffer = nil
        @frame = nil
      end

      # is the mini buffer currently attached to any frame?
      def attached?
        @frame && @frame.mini_buffer == self
      end

      def render
        curses_window.erase
        curses_window << buffer.name
        curses_window.refresh
        @text_renderer.render(buffer)
      end

      def trigger(event)
        EventManager.join(
          event,
          events,
          buffer
        )
      end

      def cancel(*)
        detach
        trigger("cancel")
        buffer.clear
      end

      def done(*)
        detach
        trigger("done")
        buffer.clear
      end

      def exec_done_block(*)
        return unless @done_block
        @done_block.call(self)
      end

      private

      def resize
        super
        @text_renderer.size = text_renderer_size
      end

      def text_renderer_size
        Rect.new(
          top: top,
          left: left + buffer.name.length,
          width: width - buffer.name.length,
          height: height
        )
      end

      def default_size
        Rect.new(
          top: 0,
          left: 0,
          width: Curses.stdscr.maxx,
          height: Curses.stdscr.maxy
        )
      end
    end
  end
end
