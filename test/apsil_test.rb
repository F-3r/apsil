require_relative "../lib/tests/dsl"
require_relative "../lib/apsil"

include Tests::DSL

require_relative "./lexer_test"
require_relative "./compiler_test"
require_relative "./interpreter_test"
require_relative "./runtime_test"
