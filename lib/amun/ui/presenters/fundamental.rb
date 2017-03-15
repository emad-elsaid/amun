module Amun
  module UI
    module Presenters
      class Fundamental

        def io
          @io ||= Amun::Application.instance.buffers.find do |b|
            b.presenter == self
          end.io
        end

        def render(window)
          window.clear
          window << io.string
        end
      end
    end
  end
end
