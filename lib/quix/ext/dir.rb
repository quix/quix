
require 'quix/ext/1.9/dir' if RUBY_VERSION >= "1.9"

class Dir
  class << self
    def empty?(dir)
      entries(dir).join == "..."
    end
  end
end
