
require 'quix/ext'
require 'quix/loop_with'
require 'quix/generator'
require 'quix/diagnostic'

class Object
  include Quix::Ext
  include Quix::Generator
  include Quix::LoopWith
  include Quix::Diagnostic
end

