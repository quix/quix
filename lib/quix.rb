
require 'quix/ext/array'
require 'quix/ext/dir'
require 'quix/ext/kernel'
require 'quix/ext/object'
require 'quix/ext/pathname'
require 'quix/ext/string'

require 'quix/loop_with'
require 'quix/diagnostic'
require 'quix/vars'

class Object
  include Quix::LoopWith
  include Quix::Diagnostic
  include Quix::Vars
end

