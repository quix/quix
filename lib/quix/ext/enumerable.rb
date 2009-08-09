
require 'quix/ext/1.8.6/enumerable.rb' if RUBY_VERSION <= "1.8.6"

module Enumerable
  def group_consecutive_by
    result = Array.new
    last_value = nil
    each_with_index { |elem, index|
      value = yield(elem)
      if index == 0 or value != last_value
        result << Array.new
      end
      result.last << elem
      last_value = value
    }
    result
  end

  def build_hash
    inject(Hash.new) { |acc, elem|
      result = yield(elem)
      acc.merge!(result[0] => result[1])
    }
  end

  def take_until(&block)
    take_while { |elem|
      not block.call(elem)
    }
  end

  def drop_until(&block)
    drop_while { |elem|
      not block.call(elem)
    }
  end

  alias_method :each_consecutive, :each_cons
end
