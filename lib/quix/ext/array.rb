
require "enumerator" if RUBY_VERSION < "1.8.7"

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
end
