
require 'quix/module'

module Kernel
  unless instance_method_defined? :system_or_raise
    def system_or_raise(*args)
      unless system(*args)
        raise "system(*#{args.inspect}) failed with status #{$?.exitstatus}"
      end
    end
  end
end
