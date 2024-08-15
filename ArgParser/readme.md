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