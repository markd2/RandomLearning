# Async Sequence

To watch

  - use async/await with URLSession

--------------------------------------------------

WWDC 2021: https://developer.apple.com/videos/play/wwdc2021/10058/

* What it be
* Usage and APIs
* Adopting and building your own. 

```
@main
struct QuakesTool {
    static func main() async throws {
        let endpointURL = URL(string:
            "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!
        // skip the header line and iterate each one
        // to extract the magnitude, time, latitude and longitude
        for try await event in endpointURL.lines.dropFirst() {
            let values = event.split (separator: ",")
            let time = values [0]
            let latitude = values[1]
            let longitude = values [2]
            let magnitude = values [4]
            print( "Magnitude \(magnitude) on \(time) at \(latitude) \(longitude)"')
    }
}
```

Show as things appear - getting lines from endpoint, CSV

Could have a large download.  But emitting as we get them, feels responsive.  Can
use famliar sequence things in this context.

Like (for await in) syntax.  and map / filter / reduce.  Or in this sample, the
drop foist

How's it work.

:alot: have groundwork in teh async/await talk, but key point

Async write conucrrent code w/o callbacks w/o callbacks.

Sequene will suspend on each eleemt, and resume when it produces a value or throws.

As the name implies, just like regular sequences, except async
  - each is delivered synchronlous
  - failure is definitely a noption
  - termintes at the end of an error.
    - if failure is not an option
  - the compiler will make sure errors are handled when calling and composing

descripion of producing values over time, it might be zero or more values, and signify
completion by returning a nil from the iteror.

error is also at a terminl state.  will return nil for subsequent calls.

Dive into how that defintion works, with regular iteration.

familiar pattern, for-in loop

```
for quake in quakes {
    if quake.magnitude > 3 {
        displaySignificantEarthquate(quake)
    }
}
```

the compiler has knowledge of how this iteration should work.  What it does isn't
magic.  Does some straightforard transformations.

Roughly what the compiler does:

```
var iterator = quakes.makeIterator()
while let quake = iterator.next() {
    ... stuff
}
```

To use the new async/await, one slight operation.

```
var iterator = quakes.makeAsyncIterator()
while let quake = await iterator.next() {
    ... stuff
}
```

can now have the iteration pareticipate in the concurrency by awaiting.

rewind what it would have been if the loop was on an async sequence.

We need to await each item, reflected in the for/await/in syntax

```
for await quake in quakes {
    ... stuff
}
```

all means if you know how to use sequenc, you know how to use async sequence.

a few ways to utilize.

Can use for/await/in

Or if the sequence threows try the for try await syntax

easily iterate produced asynchronously wihtout mucking around with closures.
Even break/continue Just Work(tm)

^^ theory

Now explore the iteration further

Given a source with a async sequence.

forawaitin will wait for each item, and when it hits a termianl, hits the root.

Breaking is a good way to terminate the iteration early from inside the work.  Works just
like regular sequences.  Or use contiune as expected. We're skipping those,a nd contining
on toawait the next quake

from the download example

```
do {
    for try await quake in quakeDownload {
        .. stuff
    }
} catch {
    .. stuff
}
```

just like throwing functions, try is required for each tick where the sequance could throw.
The compiler will detect if there is a missing try.

WHen it can produce errors, you're always safe, the language enforces you to throw it
or catch.

```
// async loop over every item from a source
for await quake in quakes {
    ....
}

// but asyncSequence might throw
do {
    for try await quake in quakeDownload {
        ...
    }

} catch {
  ...
}
```

running sequentially not always desired.  maybe concurrent. make a new async task

```
Task {
    // async loop over every item from a source
    for await quake in quakes {
        ....
    }
}

// but asyncSequence might throw
Task {
    do {
        for try await quake in quakeDownload {
            ...
        }
    
    } catch {
      ...
    }
}
```

encapsualtes the iteration. This cn be useful when async sequences might run indefinitely.

Even though sequence could be indefinite, it is less common to occur.  But in world
of async behavior is more common, and somethign to consider

The facilities make this easy and safe.

Also helpful when you want to potentially cancel


```
let iteration1 = Task {
    // async loop over every item from a source
    for await quake in quakes {
        ....
    }
}

// but asyncSequence might throw
let iteration2 = Task {
    do {
        for try await quake in quakeDownload {
            ...
        }
    
    } catch {
      ...
    }
}

iteration1.cancel()
iteration2.cancel()
```

!!! Run them concurrently and terminate later on.  Just scope the work of the iteration
that might be indifite to the life of its container


Some of the API (as of iOS 15 etc). There are :alot: them.


Reading from a file via a FileHandle

```
public var bytes: AsyncBytes

for try await line in FileHandle.standardInput.bytes.lines {
}
```

filehanld has a bytes propert to an async sequence of bytes.  Can do with extension
that converts async sequence into lines.

b/c so common, URL gets some goodies too

```
public var resourceBytes: AsyncBytes
public var lines: AsyncLineSequence<AsyncBytes>

let url = URL(fileURLWithPath: "/tmp/blah")
for try await line in url.lines {
     ...
}
```

a conveinece property to get an async sequne cof lines fro mthe contents - from
file or network.  Make a nubmer of complicated tasks easy and safe.

Sometimes getting from a network need morew control over responses and authentical.

urlsession has a bytes give fron 

```
func bytes(from: URL) async throws -> (AsyncBytes, URLResponse)
func bytees(for: URLRequest) async throws -> (AsyncBytes, URLResponse)

if let (bytes, response) = try await URLSesison.sahred.bytes(from: url)
... handle response error
for try await byte in bytes {
    ... stuff
}
```

Notification also

```
public func notifications(named: Notification.Name, object: AnyObject) -> Notifications

let center = NotificationCenter.default
let notification = await center.notifications(named: .NSPersistentStoreRemoteChange).first {
    $0.userInfo[NSStoreUUIDKey] == storeUUID
} 
```

notifications can be awaited.

and you don't have to iterate - above, waiting for the first notification where something
matches

"some neat design patterns"

whole lot of new APIs, should be familiar that are on sequence
- map
- allSatisfy
- max(by:)
- prefix
- joined
- max
- dropFirst
- flatMap
- zip
- compactMap
- prefix(while:)
- min
- reduce
- min(by:)
- filter
- contains

anything you can think of for doign a sequence has an async counterpart for async sequence.

That was a lot to take in - those are cool and syntax is neat.  How can I make my own?

let's dat!  A few ways of doing it.  Will focus an adapting exiting code.  Some design
patterns that work really well.

And some fantastic facilities.

Some of the patterns - callbacks, and some delegates as well.  Anything that does not
need a response back, and is just informing of the new values, is a prime candidate

these are really common and likely already have somet

e.g.

```
class QuakeMonitor {
    var quakeHandler: (Quake) -> Void
    func startMonitoring()
    func stopMonitoring()
}
....

let monitor = QuakeMonitor()
monitor.quakeHandler = { quake in
    ...
}
monitor.startMonitoring()
monitor.stopMonitoring()
```

can use the same thing to async sequence them

```
let quakes = AsyncStream(Quake.self) { continuation in
    let monitor = QuakeMonitor()
    monitor.quakeHandler = { quake in
        continuation.yield(quake)  // Special Snoss
    }

    continuation.onTermination = { _ in
        monitor.stopMonitoring()
    }
    monitor.startMonitoring()
}
```

use the same interface to adapt the usage.  

when making a stream, elemeent type in the closure is specified.
Yield, finsih, or t erminatel

So make the monitor in the closure. then assign to yield, and onTermination
can handle the cancellation.

The same monitor code can be enacapsuled in a stream construction.

and how it would work

```
let significantQuakes = quakes.filter { quake in
    quake.magnitude > 3
}

for await quake in significantQuakes {
   .. 
}
```

(interesting - the filter is making a sequence that is then subsequently
used)

can use the powerful transmation functions to work on intent of code rather
than bookkeeppiing.

async stream is a great way to adapt code.

handles all the things you'd expect from an async sequence
  - safety
  - buffering
  - cancellation

```
public struct AsyncStream<Element>: AsyncSequence {
    public init(
        _ elementType: Element.Type = Element.self,
        maxBufferedElements limit: Int = .max,
        _ build: (Continuation) -> Void
    )
}
```

the only source of elements if from the construcution

also AsyncThrowingStream<Element>

