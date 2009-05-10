
class Object
  alias_method :try, :__send__
  NilClass.class_eval {
    def try(*args, &block)
      nil
    end
  }
end

