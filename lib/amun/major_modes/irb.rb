require 'amun/object'
require 'amun/helpers/colors'
require 'amun/behaviours/emacs'

module Amun
  module MajorModes
    #  mode that executes the last line in
    # the current environment and print the output
    class IRB < Object
      include Behaviours::Emacs

      def initialize(buffer)
        super()
        self.buffer = buffer

        emacs_behaviour_initialize
        bind "\n", self, :execute_last_line
        read_io if buffer.empty?
      end

      def execute_last_line(*)
        result = eval(buffer[buffer.rindex("\n").to_i..-1]).inspect
        buffer << "\n#{result}"
        buffer.point = buffer.length
      rescue StandardError => error
        buffer << error.inspect.to_s
        buffer << error.backtrace.join("\n")
        buffer << "\n"
        buffer.point = buffer.length
      end

      private

      attr_accessor :buffer

      def read_io
        buffer << buffer.io.read
      end
    end
  end
end
