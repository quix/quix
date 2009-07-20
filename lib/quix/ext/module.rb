
class Module
  #
  # define_public_method
  # define_protected_method
  # define_private_method
  # define_module_function
  #

  # TODO: jettison 1.8.6; remove eval and use |&block|
  code = [
    :public,
    :protected,
    :private,
    :module_function
  ].inject("") { |acc, scope|
    name = scope == :module_function ? scope : "#{scope}_method"
    # TODO: fix rcov %{} bug
    acc << %^
      def define_#{name}(name, &block)
        define_method(name, &block)
        #{scope}(name)
      end
    ^
  }
  eval(code)
end
