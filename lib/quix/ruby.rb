
module Quix
  module Ruby
    module_function

    def executable
      require 'rbconfig'

      name = File.join(
        Config::CONFIG["bindir"],
        Config::CONFIG["RUBY_INSTALL_NAME"]
      )

      if Config::CONFIG["host"] =~ %r!(mswin|cygwin|mingw)! and
          File.basename(name) !~ %r!\.(exe|com|bat|cmd)\Z!i
        name + Config::CONFIG["EXEEXT"]
      else
        name
      end
    end

    def run(*args)
      cmd = [executable, *args]
      unless system(*cmd)
        cmd_str = cmd.map { |t| "'#{t}'" }.join(", ")
        raise "system(#{cmd_str}) failed with status #{$?.exitstatus}"
      end
    end

    def run_code_and_capture(code)
      IO.popen(%{"#{executable}"}, "r+") { |pipe|
        pipe.print(code)
        pipe.flush
        pipe.close_write
        pipe.read
      }
    end

    def run_file_and_capture(file)
      unless File.file? file
        raise "file does not exist: `#{file}'"
      end
      IO.popen(%{"#{executable}" "#{file}"}, "r") { |pipe|
        pipe.read
      }
    end
      
    def with_warnings(value = true)
      previous = $VERBOSE
      $VERBOSE = value
      begin
        yield
      ensure
        $VERBOSE = previous
      end
    end
      
    def no_warnings(&block)
      with_warnings(nil, &block)
    end
  end
end
