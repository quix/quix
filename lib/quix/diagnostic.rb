
module Quix
  module Diagnostic
    module_function

    def show(desc = nil, stream = STDOUT, &block)
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

    if $DEBUG
      def debug
        yield
      end

      def debugging?
        true
      end

      def trace(desc = nil, &block)
        if desc
          show("#{desc}.".sub(%r!\.\.+\Z!, ""), STDERR, &block)
        else
          show(nil, STDERR, &block)
        end
      end
    else
      # non-$DEBUG
      def debug ; end
      def debugging? ; end
      def trace(*args) ; end
    end
  end
end

