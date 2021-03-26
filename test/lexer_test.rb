suite "Lexer tests"

test "Lexer understands block open and block close" do
  a = Apsil::Lexer.new("[]").tokenize
  b = [
    Apsil::Lexer::Token.new(:block_open, "["),
    Apsil::Lexer::Token.new(:block_close, "]")
    ]
  assert a == b
end

test "Lexer understands integer numbers" do
  a = Apsil::Lexer.new("1234 -1234").tokenize

  b = [
    Apsil::Lexer::Token.new(:int, "1234"),
    Apsil::Lexer::Token.new(:int, "-1234"),
    ]
  assert a == b
end

test "Lexer understands real numbers" do
  a = Apsil::Lexer.new("1.234 -1.234").tokenize
  b = [
    Apsil::Lexer::Token.new(:real, "1.234"),
    Apsil::Lexer::Token.new(:real, "-1.234"),
    ]
  assert a == b
end


test "Lexer understands real symbols" do
  a = Apsil::Lexer.new(":asdf").tokenize
  b = [
    Apsil::Lexer::Token.new(:symbol, ":asdf"),
    ]
  assert a == b
end

test "Lexer understands names" do
  a = Apsil::Lexer.new("asdf").tokenize
  b = [
    Apsil::Lexer::Token.new(:name, "asdf"),
    ]
  assert a == b
end

test "Lexer understands strings" do
  a = Apsil::Lexer.new('"asdf"').tokenize
  b = [
    Apsil::Lexer::Token.new(:string, '"asdf"')
  ]

  assert a == b
end

test "Lexer understands strings that contain other tokens" do
  a = Apsil::Lexer.new('"asdf ][ $!@#$% 98 9.8"').tokenize
  b = [
    Apsil::Lexer::Token.new(:string, '"asdf ][ $!@#$% 98 9.8"'),
  ]

  assert a == b
end

test "Lexer parses escaped caracters correctly" do
  a = Apsil::Lexer.new('"\n" "\n" "\n"').tokenize
  b = [
    Apsil::Lexer::Token.new(:string, '"\n"'),
    Apsil::Lexer::Token.new(:string, '"\n"'),
    Apsil::Lexer::Token.new(:string, '"\n"'),
  ]

  assert a == b
end


test "Lexer understands all tokens" do
  a = Apsil::Lexer.new('"asdf" [ asdf :asdf ] [] [1234 [ qwer ] 1.1234]').tokenize
  b = [
    Apsil::Lexer::Token.new(:string, '"asdf"'),
    Apsil::Lexer::Token.new(:block_open, "["),
    Apsil::Lexer::Token.new(:name, "asdf"),
    Apsil::Lexer::Token.new(:symbol, ":asdf"),
    Apsil::Lexer::Token.new(:block_close, "]"),
    Apsil::Lexer::Token.new(:block_open, "["),
    Apsil::Lexer::Token.new(:block_close, "]"),
    Apsil::Lexer::Token.new(:block_open, "["),
    Apsil::Lexer::Token.new(:int, "1234"),
    Apsil::Lexer::Token.new(:block_open, "["),
    Apsil::Lexer::Token.new(:name, "qwer"),
    Apsil::Lexer::Token.new(:block_close, "]"),
    Apsil::Lexer::Token.new(:real, "1.1234"),
    Apsil::Lexer::Token.new(:block_close, "]"),
  ]

  assert a == b
end

test "Lexer detects unbalanced brackets" do
  assert_raises Apsil::Lexer::Error do
    Apsil::Lexer.new("[ [ [ ]").tokenize
  end

  assert_raises Apsil::Lexer::Error do
    Apsil::Lexer.new("[ ] ] ]").tokenize
  end
end

test "Lexer detects invalid chars" do
  %w[:].each do |char|
    assert_raises Apsil::Lexer::Error do
      Apsil::Lexer.new(char).tokenize
    end
  end
end
