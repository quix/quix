
module Quix
  module Once
    @memo = Hash.new

    module_function

    def once(&block)
      caller_index = (
        if defined?(RUBY_ENGINE)
          2
        else
          # presumably 1.8 MRI
          0
        end
      )
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

