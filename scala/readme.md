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