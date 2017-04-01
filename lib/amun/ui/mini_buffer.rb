require 'amun/application'
require 'amun/ui/buffer'
require 'amun/event_manager'

module Amun
  module UI
    class MiniBuffer < Buffer
      def initialize(name)
        bind_events
        super name
      end

      def height
        text.strip.count("\n") + 1
      end

      def attach(frame = Amun::Application.frame)
        @frame = frame
        @frame.mini_buffer = self
      end

      def detach
        @frame.mini_buffer = nil
        @frame = nil
      end

      def attached?
        @frame && @frame.mini_buffer == self
      end

      def trigger(event)
        super
        EventManager::INTERRUPTED
      end

      def render(window)
        window.clear
        window << name
        render_major_mode(window) if window.maxx > name.length
      end

      def cancel(*)
        detach
        events.trigger("cancel")
        self.text = nil
      end

      def done(*)
        detach
        events.trigger("done")
        self.text = nil
      end

      private

      def render_major_mode(window)
        mode_window = window.subwin(
          window.maxy, window.maxx - name.size,
          window.begy, window.begx + name.length
        )
        major_mode.render(mode_window)
      ensure
        mode_window.close
      end

      def bind_events
        events.bind "\e", self, :cancel
        events.bind "\C-g", self, :cancel
        events.bind "\n", self, :done
      end
    end
  end
end
