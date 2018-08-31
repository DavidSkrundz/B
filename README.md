# 🅱️

_It's like C, but 🅱️etter™️._ (Actually worse in every way)


## Requirements

###### macOS
- Install command line developer tools (Xcode)
- Install [brew](https://brew.sh)
- `brew cask install mactex`

###### Ubuntu
- `sudo apt-get install texlive-full`

###### Windows
- No idea™️


## Building

(Optional) Documentation:

```Bash
cd docs
make
```

Bootstrap the compiler (`bin/bc`):

```Bash
git checkout bootstrap
./bootstrap.sh [--update] [--keep-old]
```

While developing:

```Bash
make clean    # Remove build/
make          # Build stage1, stage2, and the new bc
make test     # Run the new bc against the test cases
make install  # Copy build/bc to bin/bc (if the tests pass)
```

## Things to do

- Add associated functions to enums (similar to values, looked up with symbols)
- Rewrite `resolveExpressionDot` to handle `Enum.Case`, `Struct.Field`, and `struct.field`
- `resolveExpressionArrow` should dereference the value then call `resolveExpressionArrow`

## Things to do (eventually)

- Rvalue/Lvalue (warn about write-only variables)
- Overload functions (with swift labels?)
- Unions + nested struct/union
- Allow `.` to get a struct field (currently only `->` on a pointer works)
- Allow `Struct.Field` to resolve the symbol of that field for use in `sizeof` and `offsetof`
- Custom operators implemented as functions
- Allow keywords to be used as second-level identifiers (enum cases, struct fields, ...)
- Static arrays (lookup tables)
- Integer conversion for literals
- Convert the C codegen into a module to allow multiple targets
- Escape characters for string and character literals
- Automatic conversion to and from `Void*`, `Void**`, etc.
- Ensure all paths in a function returns
- Add `@noreturn` attribute
- Unused declaration detection
- Add `let` keyword to prevent mutation
- `for` loops
- Fix C codegen to allow having structs in struct (only pointer work now)
- Floating point number support
- Support inlined functions
- Represent the `Int` family as structs that wrap hidden primitives (eg. `__builtin_int`)
- Line comments
- Block comments (with nesting)
- Improve VSCode plugin with compile/debug/autocompletion features
- When `make test` fails to compile running it again gives a different, irrelevant error
