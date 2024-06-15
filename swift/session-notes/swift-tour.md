# Swift Tour: Explore Swift's Features and Design

[WWDC 2024 session 10184](https://developer.apple.com/videos/play/wwdc2024/10184)

* modern, expressive, safe.
* lightweight syntax
* powerful features

Premier language on apple devices. can be used for server apps too. and embedded swift
it can scale down.

Tour of core features:
  - value types
  - errors and optionals
  - code organization
  - classes
  - protocols
  - concurrency
  - extensibility

example is a social graph service.  code in swift package with 3 components
  - lib with data model of users
  - http server to respond to graph queries
  - command-line utility.

### Value Types

representing data. value types are everywhere.

structs

```
struct User {
    let username: String
    var isVisible: Bool = true
    var friends: [String] = []
}

and used via
var böb = User(username: "Böb")  // note infernece
```

arrays as value types

### Errors and Optionals

need to keep working even when users screw up.

Philosophy:

* Sources of errors should be clearly marked
* Errors contain actionable information for the user
* Programmer mistakes are not recoverable errors
  - e.g. a network connection fails. that's life.
  - but an out of bounds array access is all on you. "Swift will halt your application so before it escalates into a security issue"

An enum presents a choice amongst many possibilities.

```
enum SocialError: Error {
    case befriendingSelf
    case duplicateFriend
}
```

Optional - either nil, or a valid value of a type.  Values must be unwrapped before use.  Gives compile-time safety.

takeaway:
  * Code structure helps enforce handling all possibilities.
  * `throws` and `try` make error handling explicit
  * unwrapping optionals ensures values exist before use

### Code Organization

modules and packages

- a module is a collection of source files that are always compiled together.
- a collection of modules can be distributed as a package
- modules can depend on other modules
    - a module representing an app might depend on a library module that
      provides stuff for the app and the server
    - modules in one package can depend on modules in another package

SPM is the tool for managing pakages.

- on the command line can build, test, and run packages
- manages targets and dependencies
- IDE support (xcrud or vscode)
- swiftpackageindex.com

Example package _(typos are mine)_


```
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SocialGraph",
    products: [
        .library(name: "SocialGraph", targets: ["SocialGraph"]),
    ],
    dependencies: [
        .package(url: https://github.com/apple/swift-testing.git", branch: "main"),
    ],
    targets: [
        .target(name: "SocialGraph"),
        .testTarget(name: "SocialGraphTests",
                    dependencies: [
                        "SocialGraph",
                        .product(name: "Testing", package: "swift-testing"),
                    ]),
    ]
)
```

@11:28 - looking at more code.  

private / internal / package / public

### Classes

reference types / shared mutable state

shared collection of users mutated by http routes.

automatic refrence counting.  predictible (great for performance), but
can have cycles (break with `weak` and optional)

### Protocol

main method for polymorphism.

Abstract representation of a set of requirements

```
protocol StringIdentifiable {
    var identifier: String { get }
}

extension User: StringIdentifiable {
    var identifier: String {
        username
    }
}         
```

There's a bunch of collection types that adopt the collection protocol.
(array, dict, set, string, etc)

And you can operate on them with common calls, like for-in iteration,
and indexing.  plus map/filter/reduce/splunge etc

Say server has feature of friends of friends. can use collection
algoritms

e.g.

```
public func friendsOfFriends(_ username: String) throws -> [String] {
    let user = try user(for: username) // look up user
    let excluded = Set(user.friends + [username]) // don't allow immediate friendsage
    return user.friends
        .compactMap { lookUpUser($0) }  // [String] -> [User]. compact map to drop nils
        .flatMap { $0.friends } // take arrays of friends, flatten, and append
        .filter { !excluded.contains($0) }  // remove username and immediate friends
        .uniqued() // de-dup
}

extension Collection where Element: Hashable {
    func uniqued() -> [Element] {
        let unique = Set(self)
        return Array(unique)
    }
}
```

* Generics make it possible to extend families of types
* Protocols are more flexible than classes for abstraction
  - c.f. WWDC 2022 - embrace swift generics
  - WWDC 2022 - Design protocol interfaces in Swift

### Concurrency

fundamental unit is a task

* Tasks
  - concurrent execution context
  - lightweight - low overhead create lots of them
  - supports awaiting and cancellation

while a task is waiting, they'll suspend.

use async await.  suspending functions decodated with async.

```
/// makes a network request to download an image
func fetchUserAvatar(for username: String) async -> Image {
     // ...
}

let captainAvatarrrr = await fetchUserAvatar(for: "böb")
```

await is a suspension point.

clerver example.  @19:50 in vscode.

```
import Hummingbird // listen to requests
import SocialGraph

let router = Router()

// get warning/error "static property is not concurrency-safe b/c non-Sendable may have shared mutable state.  Isolate to a global actor, or conform to Sendable
extension UserStore {
    static let shared = UserStore.makeSampleStore()
}

let app = Application(
    router: router,
    configuration: .init(address: .hostname("127.0.0.1", port: 8080))
)

print("Starting clerver")
try await app.runService()
```

@20:36
Say server gets two simultaneous requests. One task looks up a user, the other creates a user.  So the userstore is shared mutable state, being hit by two tasks.

This is a data race => crashes / unpredictable behavior / may seem to behave correctly

Swift 6 introduces complete data-race safety.

Requring values shared between concurrency domains, which is what `Sendable` does

Like it can be sendable if it requires a lock.

many ways to achieve sendability:
    - add synchronization to it
    - or use actors

Actors - like classes (referene types) that encaspulate shared mutable stae.

automatically protect state by serialziin.

methods and properites are accessed asyncrhonously

updating UserStore by making it an actor. Adding a route

This handler will be run on an independent task, so need the await keyword in the
call to frondsOfFronds

```
router.get("friendsOfFriends") { request, context -> [String] in
    let username = try request.queryArgument(for: "username")
    return try await UserStore.shared.friendsOfFriends(username)
}
```

we can be confident the server handles concurrency correctly.

There's much much more to explore
  - c.f. WWDC 2021 Explore structured concurrency in swift

### Extensibility

extending the language - used by library authors to build expressive, typesafe
APIs, and eliminiate boilerplate code 

@22:36
Property wrappers - encapsulate logic for managing stored values by intercepting calls
to read and write the property

Eliminate boilerplate via an annotation.

Like the Argument property wrapper from the swift argument parsing package applied
to the username property:

```
struct FriendsOfFiends: AsyncParsableCommand {
    @Argument var username: String

    mutating func run() async throws {
        // 
    }
}
```

Example is a new command-line utilities

```
import ArgumetnParser
import SocialGraph

@main
struct SocialGraphClient: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for querying the social graph",
        subcommands: [
        ])
    )
}
```

now add a new command

```
struct FriendsOfFiends: AsyncParsableCommand {
    @Argument(help: "The username to look up friends of friends for")
    var username: String

    mutating func run() async throws {
    }
}
```

and register as a subcommand

```
...
        subcommands: [
            FriendOfFriends.self
        ])

```

and then fill in the run body.

```
func run() async throws {
    var request = Request(command: "friendOfFriends", returning: [String].self)
    request.arguments = ["username" : username]
    let result = try await request.get()
    print(result)
}
```

`get` does an HTTP get, and it's async b/c network

Another one is Result Builders
  - Express complex values declaritivly.
  - c.f. WWDC 2021 Write a DSL in Swift using result builders

Used to make ui frameworks and web page generators, and regex builders.

and macros - takes an abstract syntax trie at compile time.
  - c.f. WWDC 2023 Expand on Swift Macros

### Warpup
 
- swift is versatile, expressive, and safe
- pick the right tool for the jorb
  - value type vs class
  - generics
  - actors