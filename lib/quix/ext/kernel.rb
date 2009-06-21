
module Kernel
  private
  def sys(*args)
    unless system(*args)
      args_str = args.map { |t| "'#{t}'" }.join(", ")
      raise "sys(#{args_str}) failed with status #{$?.exitstatus}"
    end
  end

  def split_options(args)
    if args.last.is_a? Hash
      [args[0..-2], args.last]
    else
      [args, Hash.new]
    end
  end
end
