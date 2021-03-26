require "byebug" if ENV["DEBUG"]
require_relative "./apsil/lexer"
require_relative "./apsil/ast"
require_relative "./apsil/compiler"
require_relative "./apsil/runtime"
require_relative "./apsil/interpreter"
require_relative "./apsil/default_runtime"
