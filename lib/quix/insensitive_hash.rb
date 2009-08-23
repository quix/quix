
require 'enumerator' unless RUBY_VERSION < "1.8.7"

module Quix
  class InsensitiveHash
    include Enumerable

    InsenstiveHashData = Struct.new(:key, :value)

    class << self
      def from_hash(hash)
        result = new
        hash.each_pair { |key, value|
          result[key] = value
        }
        result
      end

      def [](*args)
        from_hash(Hash[*args])
      end
    end

    def initialize
      @hash = Hash.new
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

    def [](key)
      t = @hash[to_neutral_key(key)]
      t and t.value
    end

    def []=(key, value)
      @hash[to_neutral_key(key)] = InsenstiveHashData.new(key, value)
      value
    end

    def clear
      @hash.clear
    end

    def default
      @hash.default
    end

    def default=(obj)
      @hash.default = obj
    end

    def default_proc
      @hash.default_proc
    end

    def delete(key, &block)
      @hash.delete(to_neutral_key(key), &block)
    end
    
    def delete_if
      if block_given?
        each_pair { |key, value|
          if yield(key, value)
            @hash.delete(to_neutral_key(key))
          end
        }
      else
        to_enum(:delete_if)
      end
    end

    def each
      @hash.each_value { |data|
        yield data.key, data.value
      }
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

    def eql?
    end

    def include?(key)
      @hash.include?(to_neutral_key(key))
    end

    alias_method :has_key, :include?

    def size
      @hash.size
    end

    def fetch(key, *args, &block)
      case args.size
      when 0
        @hash.fetch(to_neutral_key(key), &block)
      when 1
        @hash.fetch(to_neutral_key(key), args.first)
      else
        raise ArgumentError,
          "wrong number of arguments (#{args.size + 1} for 2)"
      end.value
    end

    def keys
      result = Array.new
      each_key { |key|
        result << key
      }
      result
    end
    
    def values
      result = Array.new
      each_value { |value|
        result << value
      }
      result
    end

    def merge!(hash)
      hash.each_pair { |key, value|
        self[key] = value
      }
      self
    end

    alias_method :update, :merge!

    def merge(hash)
      result = dup
      result.merge!(hash)
      result
    end

    def dup
      InsensitiveHash.from_hash(@hash)
    end

    alias_method :store, :[]=

    def to_neutral_key(key)
      key.downcase
    end
  end
end
