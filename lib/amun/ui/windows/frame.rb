require 'curses'

require 'amun/event_manager'
require 'amun/ui/echo_area'
require 'amun/ui/buffer'

module Amun
  module UI
    module Windows
      # a Frame fills all the space in terminal
      # renders an echo area and an object that
      # respond to #render and #trigger, like buffer,
      # or another window or so
      class Frame
        attr_writer :echo_area, :screen

        def echo_area
          @echo_area ||= EchoArea.new
        end

        def trigger(event)
          echo_area.trigger(event) &&
            Buffer.current.trigger(event) &&
            Amun::EventManager.trigger(event)
        rescue StandardError => e
          handle_exception(e)
        ensure
          render
        end

        def render
          render_buffer
          render_echo_area
        end

        private

        def screen
          @screen ||= Curses.stdscr
        end

        def buffer_window
          @buffer_window ||= screen.subwin(Curses.lines - 1, Curses.cols, 0, 0)
        end

        def echo_window
          @echo_window ||= screen.subwin(1, Curses.cols, Curses.lines - 1, 0)
        end

        def render_buffer
          begin
            Buffer.current.render(buffer_window)
          rescue StandardError => e
            handle_exception(e)
          end
          buffer_window.refresh
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
          echo_area.echo "#{e.message} (#{e.backtrace.first})"
        end
      end
    end
  end
end
