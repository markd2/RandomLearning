# Core Data

Project I'm on uses core data pretty heavily. I guess it's time I learned
it %-)  Most of these notes come from _Practical Core Data_ by Donny
Wals.  Swing by their [Gumroad page](https://donnywals.gumroad.com) and toss
some bucks their direction.

----------

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

Simple fetch ever-thang:

```swift
func getAllMovies() -> [Movie] {
    let fetchRequest = Movie.fetchRequest() // NSFetchRequest<Movie>
    do {
        return try persistentContainer.viewContext.fetch(fetchRequest)
    } catch {
        print("Failed to fetch movies: \(error)")
        return []
    }
}
```


And simple deleting:

```swift
func getAllMovies() -> [Movie] {
    let fetchRequest = Movie.fetchRequest() // NSFetchRequest<Movie>
    do {
        return try persistentContainer.viewContext.fetch(fetchRequest)
    } catch {
        print("Failed to fetch movies: \(error)")
        return []
    }
}
```

Every managed object has a unique objectID.

Every managed object is bound to a single managed object context, and
every managed object is unique within its context.  - so the above code
saying "hey nuke this movie" is totally good, since it's unambiguous
(via the objectID) what needs to get deleted.  be sure to save the context
to persist the change.

Updating an object is "set its properties" and then save the context.  beware
that if the user can back out of the editing, and you're adjusting the
managed object's propertie in-situ, you'll need to rollback on the
managed object context.

Can ask an object what context it belongs to

```swift
movie.managedObjectContext?.rollback()
```

But that does rollback everything.  Can isolate modifications by using
multiple managed object contexts., and dedicating a specific context
to making modifications.

----------

