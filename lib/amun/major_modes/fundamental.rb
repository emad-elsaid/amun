require 'amun/object'
require 'amun/helpers/colors'
require 'amun/behaviours/emacs'

module Amun
  module MajorModes
    # Basic mode with emacs defaults
    class Fundamental < Object
      include Behaviours::Emacs

      def initialize(buffer)
        super()
        self.buffer = buffer

        emacs_behaviour_initialize
        read_io if buffer.empty?
      end

      private

      attr_accessor :buffer

      def read_io
        buffer << buffer.io.read
      end
    end
  end
end
