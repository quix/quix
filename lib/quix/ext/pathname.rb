
require 'pathname'
require 'quix/ext/dir'

class Pathname
  def ext(new_ext)
    sub(%r!#{extname}\Z!, ".#{new_ext}")
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
    Pathname.new(yield(to_s))
  end

  def to_dos
    to_s.gsub("/", "\\")
  end

  def =~(regexp)
    to_s =~ regexp
  end

  def empty_directory?
    Dir.empty?(self.to_s)
  end

  class << self
    def join(*paths)
      Pathname.new File.join(*paths)
    end
  end
end

