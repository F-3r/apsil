suite "Apsil::Interpreter Tests"

test "pushes int values to the stack" do
  stack = Apsil::Interpreter.run("1")

  assert stack == [1]
end

test "pushes real values to the stack" do
  stack = Apsil::Interpreter.run("1.1")

  assert stack == [1.1]
end

test "pushes symbol values to the stack" do
  stack = Apsil::Interpreter.run(":asdf")

  assert stack == [":asdf"]
end

test "pushes block to the stack" do
  stack = Apsil::Interpreter.run("[ :a 1 sdf ]")

  assert stack == [
    Apsil::AST::Block.new([
      Apsil::AST::Symbol.new(":a"),
      Apsil::AST::Int.new(1),
      Apsil::AST::Name.new("sdf")
    ])
  ]
end

test "raises an error if an undefined name is used" do
  assert_raises(Apsil::Interpreter::Error) do
    stack = Apsil::Interpreter.run("1 asdf")
  end
end

test "executes the function if the name is found in the env" do
   assert_puts "1111" do
     Apsil::Interpreter.run("1111 print")
  end
end

test "prints an error with similar names if not found" do
  assert_raises Apsil::Interpreter::Error do
    assert_puts "Undefined name `nananan`. Did you mean `concat`" do
      Apsil::Interpreter.run("1111 nananan")
    end
  end
end
