
require 'fileutils'
require 'tmpdir'

module FileUtils
  module_function

  alias_method :mv__original, :mv

  def mv(source, dest, options = {})
    #
    # For case-insensitive systems, we must move the file elsewhere
    # before changing case.
    #
    temp = File.join(Dir.tmpdir, File.basename(source))
    mv__original(source, temp, options)
    begin
      mv__original(temp, dest, options)
    rescue
      mv__original(temp, source, options)
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
end
