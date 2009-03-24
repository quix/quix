
module Kernel
  def system_or_raise(*args)
    unless system(*args)
      raise "system(*#{args.inspect}) failed with status #{$?.exitstatus}"
    end
  end
end
