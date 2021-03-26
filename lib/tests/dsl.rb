require "stringio"
module Tests
  module DSL
    class Failure < StandardError; end

    def assert(assertion, msg: "Expected #{assertion} to be true, but isn't")
      unless assertion
        puts " \e[1;35m|-|\e[0m"
        raise Failure, msg
      end
    end

    def assert_raises(exception, &block)
      block.call
      assert false, msg: "expected #{exception.name} to be raised, but it wasn't"
    rescue exception
      assert true
    end

    def assert_puts(text)
      captured_stdout = StringIO.new

      orig_stdout = $stdout
      $stdout = captured_stdout

      yield

      assert captured_stdout.string.chomp == text.to_s.chomp
    ensure
      $stdout = orig_stdout
    end

    def test(name, &block)
      print name
      instance_eval(&block)
      puts " \e[1;32m|+|\e[0m"
    end

    def suite(name)
      line = "+ " + "-" * name.size + " +"

      puts
      puts line
      puts "| " + name + " |"
      puts line
      puts
    end
  end
end
