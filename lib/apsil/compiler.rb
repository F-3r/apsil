module Apsil
  class Compiler
    attr_reader :stack, :tokens

    def self.parse(code)
      new(Lexer.new(code).tokenize).ast
    end

    def initialize(tokens)
      @tokens = tokens
      @stack = []
    end

    def ast
      @tokens.each do |token|
        node = case token.name
               when :symbol
                 AST::Symbol.from_token(token)
               when :int
                 AST::Int.from_token(token)
               when :real
                 AST::Real.from_token(token)
               when :string
                 AST::String.from_token(token)
               when :name
                 AST::Name.from_token(token)
               when :block_open
                 push :block_mark
                 nil
               when :block_close
                 build_block_node.tap do
                   pop # pop :block_mark
                 end
        end

        stack.push node if node
      end

      stack
    end

    private

    def build_block_node
      items = []
      # pop node and collect them until we reach a :block mark
      items.unshift pop while peek != :block_mark

      AST::Block.new(items)
    end

    def peek
      stack.last
    end

    def push(node)
      stack.push node
    end

    def pop
      stack.pop
    end
  end
end
