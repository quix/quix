
module Quix
  module Diagnostic
    module_function

    def show(desc = nil, stream = $stdout, &block)
      if desc
        stream.puts(desc)
      end
      if block
        expression = block.call
        result = eval(expression, block.binding)
        stream.printf("%-16s => %s\n", expression, result.inspect)
        result
      end
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

