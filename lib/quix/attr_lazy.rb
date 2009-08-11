
module Quix
  #
  # Lazily-evaluated attributes.
  #
  # An attr_lazy block is evaluated in the context of the instance
  # when the attribute is requested.  The same result is then returned
  # for subsequent calls until the attribute is redefined with another
  # attr_lazy block.
  #
  module AttrLazy
    def attr_lazy(name, &block)
      AttrLazy.define_reader(class << self ; self ; end, name, &block)
    end

    def attr_lazy_accessor(name, &block)
      attr_lazy(name, &block)
      AttrLazy.define_writer(class << self ; self ; end, name, &block)
    end

    class << self
      def included(mod)
        (class << mod ; self ; end).class_eval do
          def attr_lazy(name, &block)
            AttrLazy.define_reader(self, name, &block)
          end

          def attr_lazy_accessor(name, &block)
            attr_lazy(name, &block)
            AttrLazy.define_writer(self, name, &block)
          end
        end
      end

      def define_evaluated_reader(instance, name, value)
        (class << instance ; self ; end).class_eval do
          remove_method name rescue nil
          define_method name do
            value
          end
        end
      end

      def define_reader(klass, name, &block)
        klass.class_eval do
          remove_method name rescue nil
          define_method name do
            value = instance_eval(&block)
            AttrLazy.define_evaluated_reader(self, name, value)
            value
          end
        end
      end

      def define_writer(klass, name, &block)
        klass.class_eval do
          writer = "#{name}="
          remove_method writer rescue nil
          define_method writer do |value|
            AttrLazy.define_evaluated_reader(self, name, value)
            value
          end
        end
      end
    end
  end
end
