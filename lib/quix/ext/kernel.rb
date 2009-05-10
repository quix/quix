
module Kernel
  private
  def sys(*args)
    unless system(*args)
      args_str = args.map { |t| "'#{t}'" }.join(", ")
      raise "sys(#{args_str}) failed with status #{$?.exitstatus}"
    end
  end
end
