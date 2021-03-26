module Apsil
  DefaultRuntime = Runtime.define do
    fn :false do
      stack.push false
    end

    fn :true do
      stack.push true
    end

    fn :not do
      stack.push !stack.pop
    end

    binary :and, :&
    binary :or, :|

    binary :gt, :>
    binary :lt, :<
    binary :lte, :<=
    binary :gte, :>=
    binary :eq, :==
    binary :cmp, :<=>

    binary :add, :+
    binary :sub, :-
    binary :div, :/
    binary :mul, :*

    fn :pop do
      stack.pop
    end

    fn :print do
      print peek
    end

    fn :def do
      block, name = pop 2

      env[name[1..-1].to_sym] = proc { evaluate_block block }
    end

    fn :break do
      throw :break
    end

    fn :loop do
      block = pop
      catch :break do
        loop do
          evaluate_block block
        end
      end
    end

    fn :if do
      block, condition = pop 2
      evaluate_block block if condition
    end

    fn :"if-else" do
      block_true, block_false, condition = pop 3
      condition ? evaluate_block(block_true) : evaluate_block(block_false)
    end

    fn :while do
      block, condition_block  = pop 2
      last = peek

      while evaluate_block(condition_block) && pop
        stack.push last
        evaluate_block block
        last = peek
      end
    end

    fn :times do
      block, times = pop 2
      catch :break do
        times.times { evaluate_block block }
      end
    end

    fn :value do
      evaluate_block pop
    end

    fn :concat do
      a, b = pop 2

      stack.push AST::Block.new(a.items + b.items)
    end

    fn :split do
      block, index = pop 2
      stack.push AST::Block.new(block.items[0..index-1] || [])
      stack.push AST::Block.new(block.items[index..-1] || [])
    end
  end
end
