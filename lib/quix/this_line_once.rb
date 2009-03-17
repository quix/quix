
require 'quix/kernel'

module Quix
  module ThisLineOnce
    @memo = Hash.new

    class << self
      attr_reader :memo
    end

    module_function

    def this_line_once(&block)
      line = eval("caller", block.binding).first
      if line =~ %r!\(eval\)!
        raise "`this_line_once' called inside `eval'"
      end
      ThisLineOnce.memo.fetch(line) {
        ThisLineOnce.memo[line] = block.call
      }
    end
  end
end

