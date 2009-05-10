
module Quix
  module AttrScope
    module_function

    def attr_scope(object, attribute, value)
      previous = object.send(attribute)
      writer = "#{attribute}="
      begin
        object.send(writer, value)
        yield
      ensure
        object.send(writer, previous)
      end
    end
  end
end

