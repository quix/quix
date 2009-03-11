
require 'thread'

unless RUBY_PLATFORM =~ %r!cygwin!
  raise NotImplementedError, "cygwin-only module"
end

module Quix
  module Cygwin
    module_function

    def run_batchfile(file, *args)
      dos_pwd_env {
        sh("cmd", "/c", dos_path(file), *args)
      }
    end
    
    def normalize_path(path)
      path.sub(%r!/+\Z!, "")
    end
    
    def dos_path(unix_path)
      `cygpath -w "#{normalize_path(unix_path)}"`.chomp
    end
  
    def unix_path(dos_path)
      escaped_path = dos_path.sub(%r!\\+\Z!, "").gsub("\\", "\\\\\\\\")
      `cygpath "#{escaped_path}"`.chomp
    end
    
    def dos_pwd_env
      Thread.exclusive {
        previous = ENV["PWD"]
        ENV["PWD"] = dos_path(Dir.pwd)
        begin
          yield
        ensure
          ENV["PWD"] = previous
        end
      }
    end
  end
end
