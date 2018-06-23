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
./bootstrap.sh [--update]
```

While developing:

```Bash
make clean    # Remove build/
make          # Build stage1, stage2, and the new bc
make test     # Run the new bc against the test cases
make install  # Copy build/bc to bin/bc (if the tests pass)
```

## Things to do (eventually)

List of things so I don't forget.

- Better solution to string handling (in the compiler not the language)
- Introduce Symbols that the resolver and codegen modules operate on
- Dead code detection/omission
- Improve awareness of resolver in different contexts
- Ensure the resolver passes over everything
- Structs associated functions
- Unions + nested struct/union
- Allow `.` to get a struct field (currently only `->` on a pointer works)
- Improve `Context` usage to allow enum cases and struct fields to have the same name as functions
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
