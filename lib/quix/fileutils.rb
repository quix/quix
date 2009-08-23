
require 'tmpdir'
require 'quix/module'
require 'quix/ext'

module FileUtils
  polite do
    module_function

    def rename_file(file, new_name)
      #
      # For case-insensitive systems, we must move the file elsewhere
      # before changing case.
      #
      temp = File.join(Dir.tmpdir, File.basename(file))
      mv(file, temp)
      begin
        mv(temp, new_name)
      rescue
        mv(temp, file)
        raise
      end
    end
  
    def replace_file(file)
      old_contents = File.read(file)
      yield(old_contents).extend(Quix::Ext).tap { |new_contents|
        if old_contents != new_contents
          File.open(file, "wb") { |output|
            output.print(new_contents)
          }
        end
      }
    end

    def write_file(file)
      yield.extend(Quix::Ext).tap { |contents|
        File.open(file, "wb") { |out|
          out.print(contents)
        }
      }
    end
  end
end

