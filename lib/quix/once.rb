
module Quix
  module Once
    @memo = Hash.new

    module_function

    def once(&block)
      caller_index = defined?(RUBY_ENGINE) ? 2 : 0
      line = eval("caller", block.binding)[caller_index]
      if line =~ %r!\(eval\)!
        raise "`once' called inside `eval'"
      end
      Once.instance_eval {
        @memo.fetch(line) {
          @memo[line] = block.call
        }
      }
    end
  end
end

