
require 'fileutils'
require 'tmpdir'

module FileUtils
  module_function

  def rename_file(source, dest)
    #
    # For case-insensitive systems, we must move the file elsewhere
    # before changing case.
    #
    temp = File.join(Dir.tmpdir, File.basename(source))
    mv(source, temp)
    begin
      mv(temp, dest)
    rescue
      mv(temp, source)
      raise
    end
  end

  def replace_file(file)
    old_contents = File.read(file)
    new_contents = yield(old_contents)
    File.open(file, "wb") { |out|
      out.print(new_contents)
    }
    new_contents
  end

  def write_file(file)
    contents = yield
    File.open(file, "wb") { |out|
      out.print(contents)
    }
    contents
  end

  def read_file(file)
    File.open(file, "rb") { |f| f.read }
  end
end
