
class Array
  alias_method :head, :first

  def tail
    self[1..-1]
  end
end
