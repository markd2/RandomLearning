# GOLANG

* Download and install: https://go.dev/doc/install
* Getting started: https://go.dev/doc/tutorial/getting-started
* creating a module: https://go.dev/doc/tutorial/create-module
* Learning Go as an experienced programmer: https://www.reddit.com/r/golang/comments/182pbzj/learning_go_as_an_experienced_programmer/


* pkg.go.dev
* `import "rsc.io/quote"`
* `go mod tidy`


### Infoes

* function with leading capital letter can be called from outside of the package. a.k.a. _exported name_
* `:=` shortcut for declaring and initiailzing a variable in one line, with type inference
* package names should be lower case single-word names. Only the default name for imports, need not be unique across all source code
* if/switch accept an initialization

```
if err := file.Chmod(0664); err != nil {
    log.Print(err)
    return err
}
```


--------------------------------------------------

# Effective Go Notes

https://go.dev/doc/effective_go

Supposedly should read (linked in the introduction)
- language spec
- tour of go
- how to write go code
- kind of out of date (2009, "says little about the libraries and nothing about
  significant changes to the ecosystem - like build build stuff and polymorphism")

* Prevent style wars by using gofmt. 
  - tabs
  - no line length, wrap and indent with a tab if it feels too big
  - need fewer parenthesis - nothing on control structures in their syntax

* Names
  - uppercase is visible outside of its package
  - imported packages, the name becomes an accessor for the contents
    - e.g. `import "bytes"` => able to use bytes.Buffer
  - aim for short, concise, evocative packge names
  - use paths for packages in source directories.  `import "encoding/base64"`
  - avoid `import .`
  - "long names don't automatically make things more readable"
  - one-method interfaces named for the method plus an -er suffix
    - Reader, Writer, Formatter
    - match existing conventions (if you have a Read, use the standard signature, or
      a string conversion method, call it String and not ToString)
  - no underscore I

* Getters/Setters
  - no automagic support for getters and setters (Irish or otherwise)
  - not idiomatic or necessary to put Get into the getter's name 
    - e.g. an `owner` field (low-case, unexported), getter would be `Owner`, not `GetOwner`
    - the uppercase is the key to tell the field from the method
  - a setter function would be called e.g.  `SetOwner`

* semicolons
  - inferred by the lexer
  - there's rules, not worrying about it because it makes sense
  - ooh, this totally enforces the One True Brace Style. yay!

* control structures
  - no do or while, just a slightly generalized for
  - switch is more flexible than C
  - if and switch accept an optional intialization statement like for
  - break and continue take an optional label
  - also new contro lstruct ures (type switch, multiway communications multiplexor) select
  - bodies must always be brace delimited (YAY)

* if
  - accepts initialization statement
  - if `if` doesn't flow into the next statement (body ends in break/conitune/goto/return), don't include the else
    - particularly for error handling, so you don't get the pyramid of doom

```
if x > 0 {
    return y
}
```


```
if err := file.Chmod(0664); err != nil {
    log.Print(err)
    return err
}
```


* Redeclaration and reassignment
  - using := , you can do `f, err := os.Open(name)` and `d, err := f.Stat()`,
    looking like a redeclaration of err.  That is legal - it's declared in the
    first one and re-assigned in the secndm, so the stat call will reuse `err`
  - so can use := with an existing varaible provided
    - same scope as existing declaration (otherwise you get a new variable)
    - the corresponding value is assignable
    - at least one other varible that is created by the declaration
      - so in the case above, couldn't do `f, err := SomeOtherCall()`
  - pure pragmatism, allowing the use of a single err value
  - the scope of function parameters and return values is the same as the
    function body, even though lexically they are outside the braces

* For
  - similar but different from C - unifying for and while (no do-while)
  - THERE ARE THREE FORMS
    - `for init; condition; post { }` - C style
    - `for condition { }` - like a while
    - `for { }` - infinite loop
  - short declarations make it easy to declare the index variable in the loop
    - `for i := 0; i < 10; i++`
  - over an array/slice/string/map/channel, use a range clause to manage the loop
    - `for key, value := range oldMap { ... }`
  - if only need the first item in the range (say a key or index), drop the second
    - `for key := range oldMap { }`
  - if only need the second, use an underscore to nom it
    - `for _, value := range oldMap { }`
  - for strings, range breaks out individual unicode code points (a.k.a. in gospeak, Runes)
    - bad encodings nom one byte and produce the `U+FFFD` rune
  - no comma operator.  ++ and -- are not expressions.
    - "if you want to run multiple variables in a for you should use parallel
      assignment, which precludes ++ and --"
  - ooh, can do `a[i], a[j] = a[j], a[i]` without an explicit intermediate

```
// reverse a

for i, j := 0, len(a) - 1; i < j;  i, j = i + 1, j + 1 {
    a[i], a[j] = a[j], a[i] // FLEX
}
```

* Switch
  - more general than C
  - expressions need not be constants (or even integers)
    - essentially a cascaded if going from top to bottom
  - this allows writing an if-else-if-else chain
  - if there is no expression it implicitly switches on true
  - no automatic fall-through, can use a comma-separated list
    - `case  ' ' , '?', '&':
  - can use a break to terminate early by breaking to a label
  - can use a continue+label to continue an enclosing loop

```
func unhex(c byte) byte {
    switch {
    case '0' <= c && c <= '9':
        return c - '0'
    case 'a' < c && c <= 'f':
        return c - 'a' + 10
    case 'A' < c && c <= 'F':
        return c - 'A' + 10
    }
    return zero
}
```

```
Loop:
    for n: 0; n < len(src); n += size {
    switch {
    case blah:
        if something {
            break Loop  // break out of enclosing loop
        }
        if somethingelse {
            break  // just break out of the switch
        }
        // more jazz
```

* Type Switch
  - can be used to discover the dynamic type of an interface varable
  - uses the syntax of a "type assertion" with the keyword type inside
  - if the switch declares a variable in the expression, it will have the
    corresponding type in each clause
  - idiomatic to reuse the name

```
var t interface {}
t = functionOfSomeType()
switch t := t.(type) {
default:
    fmt.Printf("unexpected type %T\n", t)  // %T prints the type
case bool:
    // t has type bool
case int:
    // t has type int
// etc, inclding things like *bool and *int for pointers
}
```

* Functions
  - multiple return values
  - addresses necessity of in-band error returns or modifying an inout parameter
  - so, go can return from Write a count and an error
    - "yes I wrote some bytes but not all of them because the device is full"
  - signature `func (class *Class) Blah(args) (n int, err error)`

* Named result parameters
  - stopped here