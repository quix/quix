
module Quix
  module Ext
    unless respond_to? :singleton_class
      def singleton_class
        class << self
          self
        end
      end
    end

    unless respond_to? :tap
      def tap
        yield self
        self
      end
    end
    
    unless respond_to? :let
      def let
        yield self
      end
    end

    unless respond_to? :try
      alias_method :try, :__send__
      NilClass.class_eval {
        def try(*args, &block)
          nil
        end
      }
    end
  end
end
