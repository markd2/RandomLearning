# Core Data

Project I'm on uses core data pretty heavily. I guess it's time I learned
it %-)  Most of these notes come from _Practical Core Data_ by Donny
Wals.  Swing by their [Gumroad page](https://donnywals.gumroad.com) and toss
some bucks their direction.


Standing up the stack:

```swift
import CoreData

class StorageProvider {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Splunge")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
}
```

Entities created in the editor have a backing class that lives in derived
data.  All entity classes inherit from `NSManagedObject` and are called
"managed objects"

Every managed object is connected to a managed object context.  It's a layer
or ("view") on top of one more persistent stores.

A managed object context can fetch data from a persistent store, hold on to
this data, manipulate it, insert new stuff, and so on.

Changes exist only in the managed object context until the context is savd
and all changes are written to the persistent store.

A managed object instance is always connected to a single MOC.  "Different instances of the same object can exist in different contexts" - (**same** object?)

Adding a thingie:

```swift
func saveMovie(named name: String) {
    let movie = Movie(context: persistentContainer.viewContext)
    movie.name = name
    
    do {
        try persistentContainer.viewContext.save()
        print("saved!")
    } catch {
        persistentContainer.viewContext.rollback()
        print("failed to save mov-ay \(error)")
    }
}
```

Persistent container's `viewContext` is a managed object context that is
associated with the main thread.

It's essiential that you use am anaged object context and access its objects from the thread they were created on.

In terms of optionality, marking a model propery as non-optional still
yields a swift-optional property. #lolzobjc. 

MoC hangs on to changes until told to write to its store with `save`.  If there's multiple managed context, calling save on one will not save the others

`rollback()` on a context to discard all not-yet persisted changes

NSFetchRequest for getting data. The fetch request has all the info
CoreData needs to get the exact data you want. It's executed by a managed
object context (We'll use the viewContext again in the intro stuff)

Fetch request contains
  - info about the entity looking for
  - filtering predicates
  - sorting rules
  - etc



### Random errors

using a mac app for the first thing, and seem to get different errors
randomly. Here's a smattering

* 2023-07-27 16:45:39.392645-0400 1-SplungeData[16107:1226405] [client] No error handler for XPC error: Connection invalid
* 2023-07-27 16:43:34.859419-0400 1-SplungeData[15948:1221632] [Window] Warning: Window SwiftUI.AppKitWindow 0x11e741990 ordered front from a non-active application and may order beneath the active application's windows.

