
require 'pathname'
require 'quix/ext/dir'

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

  def restring
    self.class.new(yield(to_s))
  end

  def =~(regexp)
    to_s =~ regexp
  end

  def empty_directory?
    Dir.empty?(self.to_s)
  end

  if File::ALT_SEPARATOR == "\\"
    def to_dos
      restring { |s|
        s.gsub("/", File::ALT_SEPARATOR)
      }
    end
  end

  if File::ALT_SEPARATOR
    #
    # bug: Pathname("x:\\a\\b\\c").cleanpath #=> #<Pathname:x:\a/b/c>
    # fix: Pathname("x:\\a\\b\\c").cleanpath #=> #<Pathname:x:/a/b/c>
    #
    alias_method :quix_original_cleanpath, :cleanpath
    def cleanpath
      quix_original_cleanpath.restring { |s|
        s.gsub(File::ALT_SEPARATOR, "/")
      }
    end
  end

  class << self
    def join(*paths)
      new File.join(*paths)
    end
  end
end

