
module Quix
  module InstanceEvalWithArgs
    module_function

    def with_temp_method(instance, method_name, method_block)
      (class << instance ; self ; end).class_eval do
        define_method(method_name, &method_block)
        begin
          yield method_name
        ensure
          remove_method(method_name)
        end
      end
    end

    def call_temp_method(instance, method_name, *args, &method_block)
      with_temp_method(instance, method_name, method_block) {
        instance.send(method_name, *args)
      }
    end

    def instance_eval_with_args(instance, *args, &block)
      call_temp_method(instance, :__temp_method, *args, &block)
    end
  end
end
