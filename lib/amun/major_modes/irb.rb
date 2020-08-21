require 'amun/major_modes/fundamental'
module Amun
  module MajorModes
    #  mode that executes the last line in
    # the current environment and print the output
    class IRB < Fundamental
      def initialize
        super()
        bind "\n", self, :execute_last_line
      end

      def execute_last_line(*)
        last_line = current_buffer.lines.last
        result = eval(last_line)
        current_buffer << "\n#{result}"
      rescue StandardError, SyntaxError => e
        current_buffer << "\n#{e.inspect}\n#{e.backtrace}"
      ensure
        current_buffer.point = current_buffer.length
      end
    end
  end
end
