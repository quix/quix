
require "enumerator" if RUBY_VERSION < "1.8.7"

class Array
  alias_method :head, :first

  def tail
    self[1..-1]
  end
end
