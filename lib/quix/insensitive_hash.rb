
class InsensitiveHash
  include Enumerable

  class << self
    def from_hash(hash)
      InsensitiveHash.new.tap { |result|
        hash.each_pair { |key, value|
          result[key] = value
        }
      }
    end
  end

  def initialize
    @hash = Hash.new
  end

  def ==(other)
    if other.is_a? InsensitiveHash
      other_hash = other.instance_eval { @hash }
      if @hash.size == other_hash.size
        @hash.each_pair { |key, data|
          canonical_key = other_hash.to_canonical_key(key)
          unless other_hash.has_key? canonical_key
            return false
          end
          unless other_hash[canonical_key] == data.value
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
    @hash[to_canonical_key(key)] = InsenstiveHashData.new(key, value)
    value
  end

  alias_method :[]=, :store

  def fetch(key, default = nil, &block)
    @hash.fetch(to_canonical_key(key), default).fetch(&block).value
  end

  def [](key)
    t = @hash[to_canonical_key(key)]
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

  def merge(hash)
    dup.tap { |result|
      result.merge!(hash)
    }
  end

  def dup
    InsensitiveHash.from_hash(@hash)
  end

  alias_method :update, :merge!

  InsenstiveHashData = Struct.new(:key, :value)

  def to_canonical_key(key)
    key.downcase
  end
end

