
module Quix
  module RestrictedValue
    class Error < RuntimeError
    end

    class << self
      def new(*allowed)
        Class.new do
          def initialize(value)
            self.value = value
          end
          
          attr_reader :value
          
          define_method :value= do |value|
            unless allowed.include? value
              raise Error,
              "RestrictedValue: `#{value.inspect}' not in #{allowed.inspect}"
            end
            @value = value
          end
        end
      end
    end
  end
end
