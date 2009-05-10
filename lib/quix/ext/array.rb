
require "enumerator" if RUBY_VERSION < "1.8.7"

class Array
  alias_method :head, :first

  def tail
    self[1..-1]
  end

  def each_slice_of(n)
    if block_given?
      (0...size).step(n) { |i|
        yield self[i, n]
      }
      self
    else
      to_enum(:each_slice_of, n)
    end
  end
end
