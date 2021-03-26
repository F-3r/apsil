module Apsil
  module AST
    class Node
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def ==(other)
        other.is_a?(Node) && other.value == value
      end
    end

    class Symbol < Node
      def self.from_token(token)
        new(token.value)
      end
    end

    class Int < Node
      def self.from_token(token)
        new(Integer(token.value))
      end
    end

    class Real < Node
      def self.from_token(token)
        new(Float(token.value))
      end
    end

    class Name < Node
      def self.from_token(token)
        new(token.value)
      end
    end

    class String < Node
      def self.from_token(token)
        new(token.value.undump)
      end
    end

    class Block < Node
      def items
        value
      end
    end
  end
end
