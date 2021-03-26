# Apsil

`Apsil` is a minimal stack-based programming language, inspired by PostScript, born after reading the [PostScript reference manual](https://web.archive.org/web/20170218093716/https://www.adobe.com/products/postscript/pdfs/PLRM.pdf) where the concepts are so well explained that was really hard to not build something afterwards.


## Grammar

In `Apsil`, like in postcript, everything is an object.

The grammar is tiny. In eBNF it would look more or less like:

```
program := block
block := [ object* ]
object := literal | block
literal = :symbol | :name  | :real | :int | :string
```

a program is a **Block** of code.

a **Block** is a list of **Objects** delimited by square brackets.

An **Object** can be:
   - **symbols**: any sequence of non-space characters nor brackets that start with a colon. Eg `:this`, `:that`, `:?`
   - **names**: any sequence of non-space characters nor brackets that doesn't start with a colon. Eg `this`, `that`, `?`
   - **Integers**: Eg `123`, `-123`
   - **Reals**: Eg. `123.4` , `-123.4567`
   - **strings**: double quote-delimited sequence of characters. Eg: `"This is not a string"`
   - **block**: to close the loop, blocks are objects too


A program in apsil looks more or less like:


```
"\n"
"!"
"world"
" "
"hello"

[ print pop ] 5 times
```

It doesn't care at all about whitespace or newlines. This is exactly the same program:

```
"
"
"!"



        "world"
          " "
        "hello"




                                             [
         print
     pop                                     ]
   5
times

```

## Semantics

The apsil interpreter has 2 main structures:

- the `stack`
- the `environment` (or `env`) which is a dictionary of (name, function) pairs

The semantics are pretty basic:

* When `apsil` finds an object, it pushes it onto the stack.
* When it finds a `name` it looks for that name in the env and executes the associated function.
* operations use the objects in the stack to perform their purpose


## Interpreter

There's a single executable `bin/apsil` which:

1) if you specify a file it will parse and interpret that file
2) if you don't specify a file to run, it starts an interactive interpreter, where you can send lines one at a time and the interpreter will parse and execute them as you press enter printing the status of the stack after each instruction.

## Types

There are 4 data types:

* `Int` (eg: `1` `-1`)
* `Real` (eg: `1.23` `-1.23`)
* `Symbols` (eg: `:something`)
* `Strings` (eg: "hello")

and 2 boolean values: `true` & `false`

The type system is almost non-existent apart from the literals, type errors are not managed by the runtime yet.
_(means: expect a lot of Exceptions rising from Ruby directly when doing something forbidden on a given type. Sorry)_


## Runtime

The runtime is just a populated `env`.

Currently, there are a few functions implemented:

* basic arithmetic operations: `add` `sub` `div` `mul`

* basic boolean operations: `and`, `or`, `not`

* basic comparison: `<` `>` `<=` `>=` `=` `<=>`

* basic flow control instructions: `if` `if-else` `loop` `while` and `times`

* basic block operations: `concat` `split` `value`

* and `def` that lets you associate *objects* with *names* in the *Env*

You can see the implementation of these in `/lib/apsil.rb`

## metaprogramming

_Code is data, and data is code._

In `apsil` your program is a block, and blocks can be evaluated (with `value`)
So you should be able to write a program that writes programs an evaluate them.

TODO: we want examples


## Extending the runtime

There are 2 ways of extending the language:

1) using `def` to define custom operations
2) defining a new runtime file using the same DSL the default runtime uses to define the basic functions (see: lib/apsil.rb). The custom env file can be passed to the interpreter as a command line argument. The interpreter will then merge both envs giving priority to the customized one.


## Testing & hacking

If you want to play with the code, there are some basic tests for the lexer, parser, interpreter and runtime functions.

You can run them with `ruby tests/apsil_test.rb`


## TODO
* examples
* self-documented runtime reference
* The error reporting is complete crap: ruby's stacktraces and exceptions all over. Not fun.
* quotes inside strings
* a module system to modularize or scope the runtime
