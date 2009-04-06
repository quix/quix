
require 'quix/ext'
require 'quix/loop_with'
require 'quix/diagnostic'
require 'quix/vars'

require 'quix/pathname'
require 'quix/array'
require 'quix/dir'
require 'quix/string'
require 'quix/kernel'

class Object
  include Quix::Ext
  include Quix::LoopWith
  include Quix::Diagnostic
  include Quix::Vars
end

