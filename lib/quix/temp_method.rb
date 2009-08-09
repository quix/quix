
require 'quix/symbol_generator'

module Quix
  module TempMethod
    module_function

    def with_temp_method(instance, method_prefix, method_block)
      method_name = "#{method_prefix}[#{SymbolGenerator.gensym}]"
      (class << instance ; self ; end).class_eval do
        define_method(method_name, &method_block)
        begin
          yield method_name
        ensure
          remove_method(method_name)
        end
      end
    end

    def call_temp_method(instance, method_prefix, *args, &method_block)
      with_temp_method(instance, method_prefix, method_block) { |method_name|
        instance.send(method_name, *args)
      }
    end
  end
end
