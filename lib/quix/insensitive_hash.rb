
module Quix
  class InsensitiveHash
    include Enumerable

    #######################################################
    # InsensitiveHash-specific implementation

    DataPair = Struct.new(:key, :value)

    def to_neutral_key(key)
      key.downcase rescue key
    end

    def dup
      result = InsensitiveHash.new
      each_pair { |key, value|
        result[key] = value
      }
      result.taint if self.tainted?
      result
    end

    class << self
      def from_hash(hash)
        result = new
        hash.each_pair { |key, value|
          result[key] = value
        }
        result
      end
    end

    #######################################################
    # Hash implementation

    class << self
      def [](*args)
        from_hash(Hash[*args])
      end
    end

    def initialize(*args, &block)
      @hash = Hash.new
      @default_proc = block
      @default = nil

      if block
        unless args.empty?
          raise ArgumentError, "wrong number of arguments"
        end
      else
        case args.size
        when 0
        when 1
          @default = args.first
        else
          raise ArgumentError,
          "wrong number of arguments (#{args.size + 1} for 2)"
        end
      end
    end

    def ==(other)
      begin
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
      rescue NoMethodError
        false
      end
    end

    def [](key)
      if data = @hash[to_neutral_key(key)]
        data.value
      elsif @default
        @default
      elsif @default_proc
        @default_proc.call(self, key)
      elsif method(:default).arity == 1
        default(key)
      else
        nil
      end
    end

    def []=(key, value)
      @hash[to_neutral_key(key)] = DataPair.new(key, value)
      value
    end

    def clear
      @hash.clear
      self
    end

    def default
      @default
    end

    def default=(obj)
      @default_proc = nil
      @default = obj
    end

    def default_proc
      @default_proc
    end

    def delete(key)
      neutral_key = to_neutral_key(key)
      if @hash.has_key?(neutral_key)
        @hash.delete(neutral_key).value
      elsif block_given?
        yield key
      else
        nil
      end
    end
    
    def delete_if
      dup.each_pair { |key, value|
        if yield(key, value)
          @hash.delete(to_neutral_key(key))
        end
      }
      self
    end

    def each
      @hash.each_value { |pair|
        yield pair.key, pair.value
      }
      self
    end

    def each_key
      each_pair { |key, value|
        yield key
      }
    end

    alias_method :each_pair, :each

    def each_value
      each_pair { |key, value|
        yield value
      }
    end
    
    def empty?
      @hash.empty?
    end

    alias_method :eql?, :==
    
    def fetch(key, *args, &block)
      result = (
        case args.size
        when 0
          @hash.fetch(to_neutral_key(key), &block)
        when 1
          @hash.fetch(to_neutral_key(key), args.first)
        else
          raise ArgumentError,
          "wrong number of arguments (#{args.size + 1} for 2)"
        end
      )
      result.value rescue result
    end

    def has_key?(key)
      @hash.has_key?(to_neutral_key(key))
    end

    def has_value?(target)
      each_value { |value|
        if target == value
          return true
        end
      }
      false
    end

    def hash
      @hash.hash
    end

    alias_method :include?, :has_key?

    def index(target)
      each_pair { |key, value|
        if target == value
          return key
        end
      }
      nil
    end

    # indexes, indices deprecated

    def initialize_copy(hash)
      delete_if { true }
      hash.each_pair { |key, value|
        self[key] = value
      }
    end

    def inspect
      to_hash.inspect
    end

    def invert
      to_hash.invert
    end

    alias_method :key?, :has_key?

    def keys
      result = Array.new
      each_key { |key|
        result << key
      }
      result
    end

    def length
      @hash.length
    end

    alias_method :member?, :has_key?

    def merge(hash)
      result = dup
      result.merge!(hash)
      result
    end

    def merge!(hash)
      hash.each_pair { |key, value|
        self[key] = value
      }
      self
    end

    def rehash
      @hash.rehash
      self
    end

    def reject(&block)
      result = dup
      result.delete_if(&block)
      result
    end

    def reject!(&block)
      changed = false
      dup.each_pair { |key, value|
        if yield(key, value)
          @hash.delete(to_neutral_key(key))
          changed = true
        end
      }
      if changed
        self
      else
        nil
      end
    end

    alias_method :replace, :initialize_copy

    public :replace

    def select(&block)
      to_a.select(&block)
    end

    def shift
      key, pair = @hash.shift
      [pair.key, pair.value]
    end
    
    alias_method :size, :length

    def sort(&block)
      to_a.sort(&block)
    end

    alias_method :store, :[]=

    def to_a
      result = Array.new
      each_pair { |key, value|
        result << [key, value]
      }
      result
    end  

    def to_hash
      result = Hash.new
      each_pair { |key, value|
        result[key] = value
      }
      result
    end

    def to_s
      to_hash.to_s
    end

    alias_method :update, :merge!

    alias_method :value?, :has_value?

    def values
      result = Array.new
      each_value { |value|
        result << value
      }
      result
    end

    def values_at(*keys)
      keys.map { |key|
        self[key]
      }
    end
  end
end
