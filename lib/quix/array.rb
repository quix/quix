
class Array
  alias_method :head, :first

  def tail
    self[1..-1]
  end

  def group_every(n)
    Array.new.tap { |result|
      count = 0
      each { |elem|
        if count % n == 0
          result << []
        end
        result.last << elem
        count += 1
      }
    }
  end
end
