
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
          Vars.argument_cache.value = value
          eval("#{name} = #{Vars.name}.argument_cache.value", block.binding)
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
      Vars.argument_cache.value = code
      vars, bind = private__eval_config_code
      vars.each { |var|
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

    class << self
      attr_accessor :argument_cache
    end
    @argument_cache = ThreadLocal.new

    def private__eval_config_code
      eval %{
        #{Vars.argument_cache.value}

        [local_variables, binding]
      }
    end
  end
end

