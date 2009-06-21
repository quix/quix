
class Pathname
  def to_dos
    restring { |s|
      s.gsub("/", File::ALT_SEPARATOR)
    }
  end

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
