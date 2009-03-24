
class InsensitiveHash
  include Enumerable

  class << self
    def from_hash(hash)
      new.tap { |result|
        hash.each_pair { |key, value|
          result[key] = value
        }
      }
    end
  end

  def initialize
    @hash = Hash.new
  end

  def has_key?(key)
    @hash.has_key?(to_neutral_key(key))
  end

  def size
    @hash.size
  end

  def ==(other)
    if other.is_a? Hash
      if @hash.size == other.size
        each_pair { |key, value|
          unless other.has_key?(key) and other[key] == value
            return false
          end
        }
        true
      else
        false
      end
    else
      false
    end
  end

  def store(key, value)
    @hash[to_neutral_key(key)] = InsenstiveHashData.new(key, value)
    value
  end

  alias_method :[]=, :store

  def fetch(key, default = nil, &block)
    @hash.fetch(to_neutral_key(key), default).fetch(&block).value
  end

  def [](key)
    t = @hash[to_neutral_key(key)]
    t and t.value
  end

  def clear
    @hash.clear
  end

  def each_pair
    @hash.each_value { |data|
      yield data.key, data.value
    }
  end

  alias_method :each, :each_pair

  def each_key
    each_pair { |key, value|
      yield key
    }
  end

  def each_value
    each_pair { |key, value|
      yield value
    }
  end
  
  def keys
    Array.new.tap { |result|
      each_key { |key|
        result << key
      }
    }
  end
  
  def values
    Array.new.tap { |result|
      each_value { |value|
        result << value
      }
    }
  end

  def merge!(hash)
    self.tap {
      hash.each_pair { |key, value|
        self[key] = value
      }
    }
  end

  alias_method :update, :merge!

  def merge(hash)
    dup.tap { |result|
      result.merge!(hash)
    }
  end

  def dup
    InsensitiveHash.from_hash(@hash)
  end

  InsenstiveHashData = Struct.new(:key, :value)

  def to_neutral_key(key)
    key.downcase
  end
end

