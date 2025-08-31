# Argument Parsing

Swift argument parser: https://github.com/apple/swift-argument-parser

a bunch of property wrappers and decorators to declare command-line
arguments.  Looks very tied to compile-time.  I'm wanting to eventually
do a purely metadata-driven set of command-line arguments (so won't have
decorated swift code).  Can argument parser work with that?

From someone smarter than me: _It looks like it uses Decodable to find all the properties that correspond to arguments, so you could presumably implement a custom Decodable and off you go._

----------

So play around first with as it's intended to be.

----------

swift package init --type tool
swift build
./.build/arm64-apple-macosx/debug/blah

----------

ArgumentParser parses the command-line arguments, instantiates the command
type, and either invokes `run()` or exits with a useful message

"uses your properties' names and type information, along with details
provided through property wrappers, to supply useful error messages and
detailed help.

Things seen

@Flag - individual flag, no value (so like boolean flags, hence the name)
@Argument - positional argument
@Option - flag with argument
@OptionGroup (includes the flags, options, and arguments 
             defined by another `ParsableArguments` type)
  - doesn't define any new arguments for a command, instead it
    splats in the arguments defined by another ParsrableArguments type
ParsableArguments
  - types that conform to this can be parsed from command-line
    arguments, but don't provide a run()
ParsableCommand
  - seems to be the one with the `run`
  - can have multiples (guess for subcommands)
  - an Async version that gives an async context
CommandConfiguration
ExpressibleByArgument
ValidationError
run()
parseOrExit()

.customLong("")
.customShort("")


./blah --decimation-simple a=b,c=d,e=f,g=h greeble.mov --poses --model

./blah --generate-model --poses --model pile-o-photos out.udsz

