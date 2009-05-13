
module Quix
  module Assert
    class AssertionFailed < StandardError
    end

    module_function

    def assert(&block)
      if $DEBUG
        expression = block.call.strip
        unless eval(expression, block.binding)
          raise AssertionFailed,
          "assertion failed: `#{expression}'"
        end
      end
    end
  end
end
