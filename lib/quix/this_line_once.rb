
require 'quix/kernel'

module Quix
  module ThisLineOnce
    @memo = Hash.new

    module_function

    def this_line_once(&block)
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
        raise "`this_line_once' called inside `eval'"
      end
      ThisLineOnce.instance_eval {
        @memo.fetch(line) {
          @memo[line] = block.call
        }
      }
    end
  end
end

