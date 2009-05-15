
require 'pp'

module Quix
  module Diagnostic
    module_function

    def show__private(inspect, format, desc, stream, &block)
      if desc
        stream.puts(desc)
      end
      if block
        expression = block.call
        result = eval(expression, block.binding)
        stream.printf(format, expression, result.send(inspect))
        result
      end
    end

    def show(desc = nil, stream = $stdout, width = 16, &block)
      show__private(:inspect, "%-#{width}s => %s\n", desc, stream, &block)
    end

    def show_pp(desc = nil, stream = $stdout, &block)
      show__private(:pretty_inspect, "%s:\n%s\n", desc, stream, &block)
    end

    def debug
      if $DEBUG
        yield
      end
    end

    def debugging?
      $DEBUG
    end

    def trace(desc = nil, &block)
      if $DEBUG
        show(desc, $stderr, &block)
      end
    end
  end
end

