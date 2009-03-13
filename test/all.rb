$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require 'quix/ruby'

Dir["#{File.dirname(__FILE__)}/test_*.rb"].each { |test|
  unless Quix::Ruby.run(test)
    raise "test failed: #{test}"
  end
}
