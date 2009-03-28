
require 'quix/ext'
require 'quix/loop_with'
require 'quix/diagnostic'

class Object
  include Quix::Ext
  include Quix::LoopWith
  include Quix::Diagnostic
end

