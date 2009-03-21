
require 'quix/kernel'

module Quix
  module ThisLineOnce
    @memo = Hash.new

    class << self
      attr_reader :memo
    end

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
      ThisLineOnce.memo.fetch(line) {
        ThisLineOnce.memo[line] = block.call
      }
    end
  end
end

