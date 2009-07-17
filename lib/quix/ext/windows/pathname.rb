
class Pathname
  def to_dos
    to_s.gsub("/", "\\")
  end

  #
  # Forward-slash invariant for all Pathnames.
  #
  alias_method :quix_original_initialize, :initialize
  def initialize(*args, &block)
    quix_original_initialize(*args, &block)
    @path.gsub!("\\", "/")
  end
end
