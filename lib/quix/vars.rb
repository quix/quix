
require 'quix/thread_local'

module Quix
  module Vars
    def eval_locals(names_block)
      names_block.call.split.each { |name|
        yield name, eval(name, names_block.binding)
      }
    end

    def hash_to_locals(&block)
      if hash = block.call
        hash.each_pair { |name, value|
          Private.argument_cache.value = value
          eval("#{name} = #{Private.name}.argument_cache.value", block.binding)
        }
      end
    end

    def locals_to_hash(&block)
      hash = Hash.new
      eval_locals(block) { |name, value|
        hash[name.to_sym] = value
      }
      hash
    end

    def each_config_pair(code, &block)
      Private.argument_cache.value = code
      locals, bind = Private.eval_code
      locals.each { |var|
        yield(var.to_sym, eval(var.to_s, bind))
      }
    end

    def config_to_hash(code)
      hash = Hash.new
      each_config_pair(code) { |name, value|
        hash[name] = value
      }
      hash
    end
    
    def hash_to_ivs(hash, *ivs)
      ivs.each { |name|
        instance_variable_set("@#{name}", hash[name.to_sym])
      }
    end

    def locals_to_ivs(&block)
      hash = Hash.new
      eval_locals(block) { |name, value|
        hash[name.to_sym] = value
      }
      hash_to_ivs(hash, *hash.keys)
    end

    def hash_to_readers(hash, *ivs)
      hash_to_ivs(hash, *ivs)
      (class << self ; self ; end).class_eval {
        ivs.each { |iv|
          attr_reader iv.to_sym
        }
      }
    end

    module Private
      @argument_cache = ThreadLocal.new
      class << self
        attr_accessor :argument_cache
        def eval_code
          code = <<-__b516c3a760b9758a47463bdb3c316bab
            lambda {
              #{::Quix::Vars::Private.argument_cache.value}

              [local_variables, binding]
            }.call
          __b516c3a760b9758a47463bdb3c316bab
          eval(code, TOPLEVEL_BINDING)
        end
      end
    end
  end
end

