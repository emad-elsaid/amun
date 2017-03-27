require 'curses'
require 'amun/event_manager'
require 'amun/ui/windows/buffer_window'
require 'amun/ui/echo_area'

module Amun
  module UI
    module Windows
      # a Frame fills all the space in terminal
      # renders an echo area and an object that
      # respond to #render and #trigger, like buffer,
      # or another window or so
      class Frame
        attr_writer :screen, :echo_area, :window

        def window
          @window ||= BufferWindow.new
        end

        def echo_area
          @echo_area ||= EchoArea.new
        end

        def trigger(event)
          EventManager.join(event, echo_area, window, EventManager)
        rescue StandardError => e
          handle_exception(e)
        ensure
          render
        end

        def render
          render_content
          render_echo_area
        end

        private

        def screen
          @screen ||= Curses.stdscr
        end

        def content_window
          @content_window ||= screen.subwin(screen.maxy - 1, screen.maxx, 0, 0)
        end

        def echo_window
          @echo_window ||= screen.subwin(1, screen.maxx, screen.maxy - 1, 0)
        end

        def render_content
          begin
            window.render(content_window)
          rescue StandardError => e
            handle_exception(e)
          end
          content_window.refresh
        end

        def render_echo_area
          begin
            echo_area.render(echo_window)
          rescue StandardError => e
            handle_exception(e)
          end
          echo_window.refresh
        end

        def handle_exception(e)
          Buffer.messages.text << "#{e.message} (#{e.backtrace.first})\n"
        end
      end
    end
  end
end
