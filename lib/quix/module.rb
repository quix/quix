
class Module
  #
  # define_public_method
  # define_protectd_method
  # define_private_method
  # define_module_function
  #
  [:public, :protected, :private, :module_function].each { |scope|
    name = scope == :module_function ? scope : "#{scope}_method"
    # TODO: jettison 1.8.6, remove eval and use |&block|
    eval %{
      def define_#{name}(name, &block)
        define_method(name, &block)
        #{scope}(name)
      end
    }
  }

  #
  # Inside a +polite+ block, a method definition is ignored if the
  # method already exists.
  #
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
