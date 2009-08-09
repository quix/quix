
require 'pathname'
require 'quix/ext/dir'
require 'quix/ext/windows/pathname' if File::ALT_SEPARATOR == "\\"

class Pathname
  def ext(new_ext)
    sub(%r!#{extname}\Z!, ".#{new_ext}")
  end

  def extword
    extname.sub(%r!\A\.!o, "")
  end

  def stem
    sub(%r!#{extname}\Z!, "")
  end

  def explode
    to_s.split(SEPARATOR_PAT).map { |path|
      self.class.new path
    }
  end

  def slice(range)
    self.class.join(explode[range])
  end

  def restring
    self.class.new(yield(to_s))
  end

  def =~(regexp)
    to_s =~ regexp
  end

  def empty_directory?
    Dir.empty?(to_s)
  end

  def write(data = nil, open_flags = ["w"])
    if data != nil and block_given?
      raise ArgumentError, "cannot pass both data and block"
    end
    contents = data == nil ? yield : data
    open(*open_flags) { |out|
      out.print(contents)
    }
    contents
  end

  def replace(open_flags_read = ["r"], open_flags_write = ["w"])
    old_contents = open(*open_flags_read) { |f| f.read }
    open(*open_flags_write) { |f|
      new_contents = yield(old_contents)
      f.write(new_contents)
      new_contents
    }
  end

  binary_encoding = RUBY_VERSION < "1.9" ? "" : ":ASCII-8BIT"
  BINARY_READ_FLAGS = "rb" + binary_encoding
  BINARY_WRITE_FLAGS = "wb" + binary_encoding

  unless method_defined?(:binread)
    def binread(length = nil, offset = nil)
      open(BINARY_READ_FLAGS) { |f|
        if offset
          f.seek(offset)
        end
        f.read(length)
      }
    end
  end

  def binwrite(data = nil, &block)
    write(data, BINARY_WRITE_FLAGS, &block)
  end

  def binreplace(&block)
    replace(BINARY_READ_FLAGS, BINARY_WRITE_FLAGS, &block)
  end

  def copy_to(dest, preserve = false)
    require 'fileutils'
    FileUtils.copy_entry(to_s, dest, preserve)
    self.class.new(dest)
  end

  def move_to(dest)
    rename(dest)
    self.class.new(dest)
  end

  class << self
    def join(*paths)
      new File.join(*paths)
    end

    def glob_all(pattern, flags = 0, &block)
      glob(pattern, flags | File::FNM_DOTMATCH, &block).reject { |path|
        path.basename =~ %r!\A\.\.?\Z!
      }
    end

    def glob_files(*args)
      glob_all(*args).select { |file| file.file? }
    end
  end
end
