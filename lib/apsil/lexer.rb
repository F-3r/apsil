require "strscan"

module Apsil
  class Lexer
    class Error < StandardError; end

    REGEXS = {
      /\s/ => nil,
      /\[/ => :block_open,
      /\]/ => :block_close,
      /\"([^"]*)\"/ => :string,
      /[\-]?[0-9]+\.[0-9]+/ => :real,
      /[\-]?[0-9]+/ => :int,
      /\:[^:\s\[\]]+/ => :symbol,
      /[^:\s\[\]][^:\s\[\]]*/ => :name,
    }.freeze

    attr_reader :code, :scanner, :tokens, :stack

    def initialize(code)
      @code = code
      @scanner = StringScanner.new(code)
      @tokens = []
      @stack = []
    end

    def tokenize
      until scanner.eos?
        regex, token = REGEXS.detect { |r, token| scanner.scan r }
        # TODO: count lines
        if regex.nil?
          raise Error, "invalid char #{code[scanner.pos]} at #{scanner.pos}"
        end

        case token
        when :block_open
          push_state :block
        when :block_close
          state = pop_state
          if state != :block
            raise Error, "Unbalanced brackets at #{code[scanner.pos]} at #{scanner.pos}. Could not finda matching opening bracket."
          end
        end

        if token
          tokens << Token.new(token, scanner.matched)
        end
      end

      raise Error, "Unbalanced brackets: there's at least one bracket that is not properly closed." if stack.any?

      tokens
    end

    def state
      stack.last || :default
    end

    def push_state(state)
      stack.push(state)
    end

    def pop_state
      stack.pop
    end

    class Token
      attr_reader :name, :value
      def initialize(name, value = nil)
        @name = name
        @value = value
      end

      def ==(other)
        other.is_a?(Token) && name == other.name && value == other.value
      end

      def ===(other)
        name == other
      end
    end
  end
end
