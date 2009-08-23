
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

  class << self
    def join(*paths)
      new File.join(*paths)
    end
  end
end

