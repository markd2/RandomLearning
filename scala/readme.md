# Scala learnage

* https://docs.scala-lang.org/getting-started/index.html
* `brew install coursier/formulas/coursier && cs setup`
* `~/Library/Application Support/Coursier/bin` into path
* make a new scala project with `sbt new scala/scala3.g8`
* run with sbt run

* `git clone https://github.com/deanwampler/programming-scala-book-code-examples.git`
* `cd programming-scala-book-code-examples/`
* `sbt test`
* should get a `[success]`

### Links

* https://www.scala-lang.org/api/current/index.html - scala standard library scaladoc documentation

### SBT / Console

* `sbt` alone starts interactive shell
* a command is adding `~` in front of a command 0 if file chnges are saved, the command
  is rerun. so `~test` is cool.  RET to break out of the loop.
* dude is using `-source:future` which emits deprecation warnings
* `scala` is a shortcut for that (though sbt pulls in libraries and compiled code in the 
  classpath.
* unsassigned values get a local debugger variable. e.g. `val res0: Int = 3`

### Misc

* `src/test/scala/.../*Suite.scala` are test files - MUnit: https://scalameta.org/munit/

### Language

* `val` - immutable value
* "type declarations" - `: Type` annotation
* `Seq[T]` - sequence.  _parameterized type_, `Seq[T]`
* `Vector[T]` - immutable array.  Subtype of Seq
* `List[T]` - immutable linked list
* `Array` - mutable.
* anonymous function literal `(s: String) => s.toUpperCase`
    - toUpperCase takes no arguments, so parens are omitted
    - can be simplified to `s => s.toUpperCase` via type inference
* `return` exists, but only for early return in methods, not anonymous functions
* _method_ is a function defined within a type, an implied _this_ reference
    - on the JVM, functions are implemented as JVM lambdas
* object vs class - (in the discusion about the different kinds of `main`), sounds
  like `object` is all static members, since there is no `static` or equivalent keyword
    - also makes it a singleton (:-( ) as a first-class citizen of the language
    - ok cool. the book mentions some drawbacks
* `def Hello(params: String*): Unit =` - the `*` is for _repeated parameters_  In this
   case an immutable Seq[String]
* `Unit` - like Void, nothing returned
* "type" = class or object
* "instance" = instantiated class
* `foreach` - to process each element of a (sequence?) and perform only side efffects.
    - vs `map` that returns a new value for each element (and avoid side effects plzkthx)
* Some fundamental types are auto-imported. Things like print* are methods on an object scala.Console
    - come from a library called Predef https://www.scala-lang.org/api/current/scala/Predef$.html
