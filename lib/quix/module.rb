
class Module
  def polite(&block)
    added =       Hash.new { |hash, key| hash[key] = Array.new }
    scope_cache = Hash.new { |hash, key| hash[key] = Array.new }
    current_scope = :public

    mod = Module.new {
      (class << self ; self ; end).module_eval {
        [:public, :protected, :private, :module_function].each { |scope|
          define_method(scope) { |*args|
            if args.empty?
              current_scope = scope
            else
              scope_cache[scope] += args
            end
          }
        }
        define_method(:method_added) { |name|
          added[current_scope] << name
        }
      }
      module_eval(&block)
    }

    added_dup = added.inject(Hash.new) { |acc, (scope, names)|
      acc.merge!(scope => names.dup)
    }

    added_dup.each_pair { |scope, names|
      names.each { |name|
        if method_defined? name
          mod.module_eval {
            remove_method(name)
          }
          added[scope].delete(name)
          scope_cache[scope].delete(name)
        end
      }
    }

    include mod

    [added, scope_cache].each { |hash|
      hash.each_pair { |scope, names|
        send(scope, *names)
      }
    }
  end
end
