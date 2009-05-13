
class Object
  def deep_dup
    Marshal.load(Marshal.dump(self))
  end
end

