
require 'quix/ext/array'
require 'quix/ext/class'
require 'quix/ext/dir'
require 'quix/ext/enumerable'
require 'quix/ext/file'
require 'quix/ext/hash'
require 'quix/ext/kernel'
require 'quix/ext/module'
require 'quix/ext/object'
require 'quix/ext/pathname'
require 'quix/ext/string'

require 'quix/diagnostic'
require 'quix/loop_with'
require 'quix/vars'

class Object
  include Quix::Diagnostic
  include Quix::LoopWith
  include Quix::Vars
end

