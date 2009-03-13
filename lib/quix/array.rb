
require 'quix/module'

class Array
  unless instance_method_defined? :head
    alias_method :head, :first
  end

  polite do
    def tail
      self[1..-1]
    end
  end
end
