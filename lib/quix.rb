# 
# Copyright (c) 2008, 2009 James M. Lawrence.  All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 

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

module Quix
  VERSION = "0.1.0"
end

class Object
  include Quix::Diagnostic
  include Quix::LoopWith
  include Quix::Vars
end

