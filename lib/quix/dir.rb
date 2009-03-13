
require 'quix/module'

class Dir
  class << self
    polite do
      def empty?(dir)
        entries(dir).join == "..."
      end
    end
  end
end
