
module Quix
  module AttrScope
    module_function

    def attr_scope(object, hash)
      previous = hash.inject(Hash.new) { |acc, (key, value)|
        acc.merge!(key => object.send(key))
      }
      hash.each_pair { |key, value|
        object.send("#{key}=", value)
      }
      begin
        yield
      ensure
        previous.each_pair { |key, value|
          object.send("#{key}=", value)
        }
      end
    end
  end
end

