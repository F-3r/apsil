suite "Runtime tests"

test "add" do
  assert [6] == Apsil::Interpreter.run("1 2 add 3 add")
end

test "loop" do
  Apsil::Interpreter.run("6 [print print print break] loop")
end

test "gt" do
  assert [true] == Apsil::Interpreter.run("6 3 gt")
  assert [false] == Apsil::Interpreter.run("3 6 gt")
end

test "lt" do
  assert [true] == Apsil::Interpreter.run("3 6 lt")
  assert [false] == Apsil::Interpreter.run("6 3 lt")
end

test "gte" do
  assert [true] == Apsil::Interpreter.run("3 2 gte")
  assert [false] == Apsil::Interpreter.run("3 4 gte")
  assert [true] == Apsil::Interpreter.run("3 3 gte")
end

test "lte" do
  assert [true] == Apsil::Interpreter.run("3 4 lte")
  assert [false] == Apsil::Interpreter.run("3 2 lte")
  assert [true] == Apsil::Interpreter.run("3 3 lte")
end

test "eq" do
  assert [false] == Apsil::Interpreter.run("3 4 eq")
  assert [true] == Apsil::Interpreter.run("3 3 eq")
  assert [true] == Apsil::Interpreter.run("3 3 eq")
end


test "true" do
  assert [true] == Apsil::Interpreter.run("true")
end

test "false" do
  assert [false] == Apsil::Interpreter.run("false")
end

test "not" do
  assert [true] == Apsil::Interpreter.run("false not")
  assert [false] == Apsil::Interpreter.run("true not")
end

test "and" do
  assert [false] == Apsil::Interpreter.run("false true and")
  assert [true] == Apsil::Interpreter.run("true true and")
  assert [false] == Apsil::Interpreter.run("false false and")
end

test "or" do
  assert [true] == Apsil::Interpreter.run("false true or")
  assert [false] == Apsil::Interpreter.run("false false or")
  assert [true] == Apsil::Interpreter.run("true true or")
end

test "if" do
  assert [] == Apsil::Interpreter.run("[0] false if")
  assert [0] == Apsil::Interpreter.run("[0] true if")

  assert [] == Apsil::Interpreter.run("[0] 2 1 lt if") #if no debería pushear algo?
  assert [0] == Apsil::Interpreter.run("[0] 2 1 gt if") # if no deberia ser un bloque la condicion
end

test "if-else" do
  assert [1] == Apsil::Interpreter.run("[0] [1] false if-else")
  assert [0] == Apsil::Interpreter.run("[0] [1] true if-else")
end

test "while" do
  assert_puts "12345" do
    Apsil::Interpreter.run("
      0
      [1 add print] [5 lt] while
    ")
  end
end

test "times" do
  assert_puts "11111" do
    Apsil::Interpreter.run("1 [print] 5 times")
  end

  assert_puts "11111" do
    Apsil::Interpreter.run("1 [print] 1 1 add 3 add times")
  end
end

test "def" do
  stack = Apsil::Interpreter.run("
    [1 add] :inc def
    1 inc
  ")
  assert [2] == stack
end

test "value" do
  stack = Apsil::Interpreter.run "[1 2 add] value"

  assert [3] == stack
end

test "concat" do
  a = Apsil::Interpreter.run "[1] [2] concat [3] concat [4] concat"
  b = [
    Apsil::AST::Block.new([
      Apsil::AST::Int.new(1),
      Apsil::AST::Int.new(2),
      Apsil::AST::Int.new(3),
      Apsil::AST::Int.new(4)
    ])
  ]

  assert a == b
end

test "split" do
  a = Apsil::Interpreter.run '["a" "b" "c" "d"] 2 split'
  b = [
    Apsil::AST::Block.new([
      Apsil::AST::String.new("a"),
      Apsil::AST::String.new("b")
    ]),
    Apsil::AST::Block.new([
      Apsil::AST::String.new("c"),
      Apsil::AST::String.new("d")
    ])
  ]

  assert a == b
end

test "code is blocks, block is codes" do
  a = Apsil::Interpreter.run(<<-CODE)
    [[1] :a def] value
    a a add
    a add
  CODE

  assert [3] == a
end
