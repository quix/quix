
require 'quix/module'

class Array
  polite do
    def rest
      self[1..-1]
    end
    
    def inject1(&block)
      tail.inject(head, &block)
    end
  end
  
  unless instance_method_defined? :head
    alias_method :head, :first
  end

  unless instance_method_defined? :tail
    alias_method :tail, :rest
  end
end
