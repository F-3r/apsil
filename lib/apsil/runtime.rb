module Apsil
  class Runtime
    attr_reader :env

    def self.load(file)
      new.load(File.read(file))
    end

    def self.define(&block)
      new.define(&block)
    end

    def initialize
      @env = {}
    end

    def load(spec)
      instance_eval(spec)
    end

    def define(&block)
      instance_eval(&block)
      self
    end

    def fn(name, &block)
      env[name] = block
    end

    def binary(name, method)
      fn name do
        a, b = pop 2
        stack.push a.method(method).call(b)
      end
    end
  end
end
