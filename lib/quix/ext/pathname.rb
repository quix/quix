
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
    Dir.empty?(self.to_s)
  end

  def draft(*open_flags)
    open_flags = ["w"] if open_flags.empty?
    contents = yield
    open(*open_flags) { |out|
      out.print(contents)
    }
    contents
  end

  def replace(open_flags_read = nil, open_flags_write = nil)
    open_flags_read ||= ["r"]
    open_flags_write ||= ["w"]

    old_contents = open(*open_flags_read) { |f| f.read }

    new_contents = nil
    open(*open_flags_write) { |f|
      new_contents = yield(old_contents)
      f.write(new_contents)
    }
    new_contents
  end

  BINARY_ENCODING = RUBY_VERSION < "1.9" ? "" : ":ASCII-8BIT"
  BINARY_READ_FLAGS = "rb" + BINARY_ENCODING
  BINARY_WRITE_FLAGS = "wb" + BINARY_ENCODING

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

  def bindraft(&block)
    draft(BINARY_WRITE_FLAGS, &block)
  end

  def binreplace(&block)
    replace(BINARY_READ_FLAGS, BINARY_WRITE_FLAGS, &block)
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
  end
end
