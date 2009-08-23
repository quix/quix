
require 'quix/module'
require 'thread'

module Kernel
  unless instance_method_defined? :singleton_class
    def singleton_class
      class << self
        self
      end
    end
  end

  unless instance_method_defined? :tap
    def tap
      yield self
      self
    end
  end

  unless instance_method_defined? :let
    def let
      yield self
    end
  end

  private

  unless instance_method_defined? :loop_with
    def loop_with(done = nil, again = nil)
      if done
        if again
          catch(done) {
            while true
              catch(again) {
                yield
              }
            end
          }
        else
          catch(done) {
            while true
              yield
            end
          }
        end
      elsif again
        while true
          catch(again) {
            yield
          }
        end
      else
        while true
          yield
        end
      end
    end
  end

  let {
    name = :gensym
    unless instance_method_defined? name
      mutex = Mutex.new
      count = 0
      define_method(name) { |*args|
        mutex.synchronize {
          count += 1
        }
        case args.size
        when 0
          :"G#{count}"
        when 1
          :"|#{args.first}#{count}|"
        else
          raise ArgumentError, "wrong number of arguments (#{args.size} for 1)"
        end
      }
      private name
    end
  }
end
