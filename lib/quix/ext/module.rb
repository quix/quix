
class Module
  #
  # define_public_method
  # define_protectd_method
  # define_private_method
  # define_module_function
  #
  [:public, :protected, :private, :module_function].each { |scope|
    name = scope == :module_function ? scope : "#{scope}_method"
    # TODO: jettison 1.8.6, remove eval and use |&block|
    eval <<-end_eval
      def define_#{name}(name, &block)
        define_method(name, &block)
        #{scope}(name)
      end
    end_eval
  }
end
