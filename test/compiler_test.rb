suite "Compiler Tests"

test "Compiler parses symbols" do
  a = Apsil::Compiler.parse(":asdf :qwer :zxcv")
  b = [
    Apsil::AST::Symbol.new(":asdf"),
    Apsil::AST::Symbol.new(":qwer"),
    Apsil::AST::Symbol.new(":zxcv")
  ]

  assert a == b
end

test "Compiler parses integers" do
  a = Apsil::Compiler.parse("1234 -1234")
  b = [
    Apsil::AST::Int.new(1234),
    Apsil::AST::Int.new(-1234)
  ]

  assert a == b
end

test "Compiler parses reals" do
  a = Apsil::Compiler.parse("1.234 -1.234")
  b = [
    Apsil::AST::Int.new(1.234),
    Apsil::AST::Int.new(-1.234)
  ]

  assert a == b
end

test "Compiler parses names" do
  a = Apsil::Compiler.parse("qwer asdf zxcv")
  b = [
    Apsil::AST::Name.new("qwer"),
    Apsil::AST::Name.new("asdf"),
    Apsil::AST::Name.new("zxcv")
  ]

  assert a == b
end


test "Compiler parses blocks" do
  a = Apsil::Compiler.parse("[] [] []")
  b = [
    Apsil::AST::Block.new([]),
    Apsil::AST::Block.new([]),
    Apsil::AST::Block.new([]),
  ]

  assert a == b
end

test "Compiler parses nested blocks" do
  a = Apsil::Compiler.parse("[ [ [] ] ]")
  b = [
    Apsil::AST::Block.new([
      Apsil::AST::Block.new([
        Apsil::AST::Block.new([]),
      ]),
    ]),
  ]

  assert a == b
end

test "Compiler parses nested blocks with values" do
  a = Apsil::Compiler.parse(" [:asdf [1 2 3] asdf]")
  b = [
    Apsil::AST::Block.new([
      Apsil::AST::Symbol.new(":asdf"),
      Apsil::AST::Block.new([
        Apsil::AST::Int.new(1),
        Apsil::AST::Int.new(2),
        Apsil::AST::Int.new(3)
      ]),
      Apsil::AST::Name.new("asdf"),
    ]),
  ]

  assert a == b
end
