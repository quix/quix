$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'quix/ruby'

def skip(test)
  # rspec fails on 1.9
  RUBY_VERSION >= "1.9.0" and File.basename(test) == 'test_reverse_range.rb'
end

#
# Run in separate exec to check for missing dependencies.
#
Dir["#{File.dirname(__FILE__)}/test_*.rb"].each { |test|
  unless skip(test)
    unless Quix::Ruby.run(test)
      raise "test failed: #{test}"
    end
  end
}
