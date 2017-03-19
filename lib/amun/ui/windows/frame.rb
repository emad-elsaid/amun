require 'curses'

require 'amun/event_manager'
require 'amun/ui/echo_area'

module Amun
  module UI
    module Windows
      # a Frame fills all the space in terminal
      # renders an echo area and an object that
      # respond to #render and #trigger, like buffer,
      # or another window or so
      class Frame
        attr_writer :echo_area

        def trigger(event)
          echo_area.trigger(event) &&
            buffer.trigger(event) &&
            Amun::EventManager.trigger(event)
        rescue StandardError => e
          echo_area.echo "#{e.message} (#{e.backtrace.first})"
        ensure
          render
        end

        def render
          buffer.render(buffer_window)
          echo_area.render(echo_area_window)
        rescue StandardError => e
          echo_area.echo "#{e.message} (#{e.backtrace.first})"
        ensure
          buffer_window.refresh
          echo_area_window.refresh
        end

        def echo_area
          @echo_area ||= Amun::UI::EchoArea.new
        end

        private

        def buffer
          Amun::Application.instance.current_buffer
        end

        def screen
          @screen ||= Curses.stdscr
        end

        def buffer_window
          @buffer_window ||= screen.subwin(Curses.lines - 1, Curses.cols, 0, 0)
        end

        def echo_area_window
          @echo_area_window ||= screen.subwin(1, Curses.cols, Curses.lines - 1, 0)
        end
      end
    end
  end
end
