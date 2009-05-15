
class Hash
  def key_sorted_each_pair
    keys.sort.each { |key|
      yield key, self[key]
    }
    self
  end

  def value_sorted_each_pair
    inverted = invert
    values.sort.each { |value|
      yield inverted[value], value
    }
    self
  end
end
