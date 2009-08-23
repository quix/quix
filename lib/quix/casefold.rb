
class << Dir
  remove_method :[]
  def [](pattern)
    Dir.glob(pattern, File::FNM_CASEFOLD)
  end

  alias_method :quix_glob_original, :glob
  def glob(pattern, flags = 0)
    quix_glob_original(pattern, File::FNM_CASEFOLD | flags)
  end
end
