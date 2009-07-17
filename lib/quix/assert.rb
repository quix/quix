
module Quix
  module Assert
    class AssertionFailed < StandardError
    end

    module_function

    def assert(&block)
      expression = block.call.strip
      unless eval(expression, block.binding)
        raise AssertionFailed, "assertion failed: `#{expression}'"
      end
    end
  end
end
