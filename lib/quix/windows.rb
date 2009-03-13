
require 'fileutils'

module Quix
  module Windows
    module_function
    
    # unix2dos/dos2unix also fix \r\r\n files arising from perforce bugs

    def unix2dos(string)
      string.gsub("\r", "").gsub("\n", "\r\n")
    end
    
    def unix2dos!(string)
      res1 = string.gsub!("\r", "")
      res2 = string.gsub!("\n", "\r\n")
      if res1.nil? and res2.nil?
        nil
      else
        string
      end
    end
    
    def dos2unix(string)
      string.gsub("\r", "")
    end

    def dos2unix!(string)
      string.gsub!("\r", "")
    end

    def avoid_dll(file)
      temp_file = file + ".avoiding-link"
      FileUtils.mv(file, temp_file)
      begin
        yield
      ensure
        FileUtils.mv(temp_file, file)
      end
    end
  end
end
