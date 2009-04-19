
module Quix
  module Misc
    module_function

    def scoped_assign(obj, attribute, value)
      previous = obj.send(attribute)
      begin
        obj.send("#{attribute}=", value)
        yield
      ensure
        obj.send("#{attribute}=", previous)
      end
    end
  end
end

