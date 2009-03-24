
require 'pathname'

class Pathname
  def ext(new_ext)
    sub(%r!#{extname}\Z!, ".#{new_ext}")
  end

  def stem
    sub(%r!#{extname}\Z!, "")
  end

  def explode
    to_s.split(::Pathname::SEPARATOR_PAT).map { |path|
      Pathname.new path
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

  class << self
    def join(*paths)
      Pathname.new File.join(*paths)
    end
  end
end

