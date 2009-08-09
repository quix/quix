
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

  #
  # build_hash appears in Gavin Sinclair's extensions package.
  #
  # This implementation is slightly different in that it skips yield
  # results of nil.
  #
  def build_hash
    result = Hash.new
    each { |elem|
      pair = yield(elem)
      unless pair.nil?
        result[pair[0]] = pair[1]
      end
    }
    result
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
