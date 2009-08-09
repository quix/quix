
class Hash
  class << self
    def of(klass, *args)
      new { |hash, key| hash[key] = klass.new(*args) }
    end
  end

  def each_pair_sort_keys
    keys.sort.each { |key|
      yield key, self[key]
    }
    self
  end

  def each_pair_sort_values
    inverted = invert
    values.sort.each { |value|
      yield inverted[value], value
    }
    self
  end

  def nonempty?
    not empty?
  end
end
