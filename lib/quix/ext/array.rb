
class Array
  alias_method :head, :first

  def tail
    self[1..-1]
  end

  [
    nil,
    :second,
    :third,
    :fourth,
    :fifth,
    :sixth,
    :seventh,
    :eighth,
    :ninth,
    :tenth,
  ].each_with_index { |method, index|
    if method
      define_method method do
        self[index]
      end
    end
  }

  def penultimate
    self[-2]
  end

  #
  # Array#split(:capture => true) imitates the behavior of
  # String#split with a regexp capture:
  #
  #   "abcd".split %r!(a)! #=> ["", "a", "bcd"]
  #   %w[a b c d].split "a", :capture => true #=> [[], "a", ["b", "c", "d"]]
  #
  #   "abcd".split %r!(b)! #=> ["a", "b", "cd"]
  #   %w[a b c d].split "b", :capture => true #=> [["a"], "b", ["c", "d"]]
  #
  #   "abcd".split %r!(c)! #=> ["ab", "c", "d"]
  #   %w[a b c d].split "c", :capture => true #=> [["a", "b"], "c", ["d"]]
  #
  #   "abcd".split %r!(d)! #=> ["abc", "d"]
  #   %w[a b c d].split "d", :capture => true #=> [["a", "b", "c"], "d"]
  #
  #   "a".split %r!(a)! #=> ["", "a"]
  #   %w[a].split "a", :capture => true #=> [[], "a"]
  #
  def split(*args)
    opts = args.last.is_a?(Hash) ? args.pop : Hash.new
    block_given = block_given?

    if block_given
      unless args.size == 0
        raise ArgumentError, "cannot pass both value and block"
      end
    elsif args.size != 1
      raise ArgumentError, "wrong number of arguments (#{args.size} for 1)"
    end

    capture = opts[:capture]
    value = args.first

    result = [[]]
    each_with_index { |elem, index|
      if (block_given and yield(elem)) or (not block_given and elem == value)
        result << elem if capture
        result << Array.new unless index == size - 1
      else
        result.last << elem
      end
    }
    result
  end
end
