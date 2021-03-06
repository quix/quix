
require 'ostruct'

module Quix
  class HashStruct < OpenStruct
    def method_missing(sym, *args, &block)
      if table.respond_to? sym
        table.send(sym, *args, &block)
      else
        super
      end
    end
    
    class << self
      def recursive_new(hash)
        result = new
        hash.each_pair { |key, value|
          result.send(
            "#{key}=",
            value.is_a?(Hash) ? recursive_new(value) : value
          )
        }
        result
      end
    end
  end
end
