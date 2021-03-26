module Apsil
  class Interpreter
    class Error < StandardError; end

    attr_reader :ast, :stack, :env

    def self.run(code)
      new.run(Compiler.parse(code))
    end

    def initialize(runtime = nil)
      @env = DefaultRuntime.env
      @env.merge! runtime.env if runtime
      @stack = []
    end

    def run(ast)
      ast.each { |node| evaluate node }
      stack
    end

    def evaluate(node)
      if node.is_a?(AST::Name)
        invoke_function(node)
      elsif node.is_a?(AST::Block)
        stack.push node
      else
        stack.push node.value
      end
    end

    def evaluate_block(block)
      raise Error, "Block expected but received #{block.class.name} instead" unless block.is_a?(AST::Block)
      block.items.each { |node| evaluate node }
    end

    def pop(n = 1)
      n == 1 ? stack.pop : stack.pop(n)
    end

    def peek
      stack.last
    end

    def invoke_function(node)
      fn = env[node.value.to_sym]

      if fn.nil?
        words = env.keys.map { |a| a.to_s.split("") }
        name = node.value.split("")
        alt = words.sort_by { |w| (w & name).size.to_f / name.size }.last&.flatten&.join

        raise Error, "Undefined name `#{node.value}`. Did you mean `#{alt}`"
      else
        instance_eval &fn
      end
    end
  end
end
