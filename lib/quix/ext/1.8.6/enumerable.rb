
require 'enumerator' 

module Enumerable
  def drop_while
    result = []
    found = false
    each { |elem|
      if found or not yield(elem)
        result << elem
        found = true
      end
    }
    result
  end

  def take_while
    result = []
    each { |elem|
      if yield(elem)
        result << elem
      else
        return result
      end
    }
    result
  end
end
