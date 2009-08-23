
require 'enumerator' if RUBY_VERSION <= "1.8.6"

require 'quix/ext/array'
require 'quix/ext/dir'
require 'quix/ext/hash'
require 'quix/ext/kernel'
require 'quix/ext/module'
require 'quix/ext/object'
require 'quix/ext/pathname'
require 'quix/ext/string'

require 'quix/assert'
require 'quix/diagnostic'
require 'quix/loop_with'
require 'quix/vars'

class Object
  include Quix::Assert
  include Quix::Diagnostic
  include Quix::LoopWith
  include Quix::Vars
end

