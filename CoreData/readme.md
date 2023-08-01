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
associated with the main thread. "the context you'd use in your (UIKit/SwiftUI)
views.

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

Core data's building blocks

persistent containers - the "Core Data Stack"

NSPersistentContainer (from iOS10 onwards) from iOS 10+ . It's a facade
over the old way.

```text
Persistent contaner -----+---- Model (NSManagedObjectModel)
(NSPersistentContainer)  |
                         +---- Managed Object Context (NSManagedObjectContext)
                         |
                         +-+-- Persistent Store Coordinator (NSPersistentStoreCoordinator)
                           |
                           +-- Underlying storage (usually aqlite)
```

Using NSPersistentContainer is the simplest apprach and is recommended
to use.

The mangled object model is the heart and soul of the CD store.
It's where the object graph lives, fetch templates are stored,
and entities / relationships / properties are defined.
(feed the NSManagedObjectModel constructor a url to an
NSManagedObjectModel - a momd file). A missing momd file is fatal.

Can build your managed object model in code by configuring :all-the-things:
via code in a custom NSManagedObjectModel subclass. "this is a tedious process"

When standing up a persistent store coordinator, give it the managed object
model it'll be using. Also derive the path for an sqlite file in the
documents directory - uset hat to tell the coordinator to `addPersistentStore`
(when using a persistent container, the default location is the
app's Application Support directory)

The persistent store coordinator is an interface on top a persistent
store, so abstracts away the specific store type.  Apps rarely deal with
persistent store coordinators directly.

Instead, go through a Managed Object Context

the managed object context is where you create / load / manipulate 
managed objects.  Can have more than one MOC in your app.  Ech
MOC has a reference to the persistent store coordinator it's cozy with.

When creating one, you give it a concurrency type
(e.g. .mainQueueConcurrencyType, vs say privateQueueConcurrencyType)
and also the persistent store coordinator.

when asking to fetch or save(), the managed object context forwards
the call up to its persistent store coordinator., which itself forwards
to the persisten store

Managed objects should only be used on the same thread as their context.
One running on the main queue can safely be used to retrieve objects
used in the app's UI. And why in a persistent container the main queue
is called `viewContext` - the one you use with views.

can have more than one managed object context connected to a
persistent store coordiantor.

e.g.:
- use your viewContext to fetch data from the core data store and show to the user
- Create a background managed object context along side the viewContext
- use this background context to import new data from a network call
  - or do costly work that might block the UI

Can also make a managed object context that's a child of another
managed object context - when you save a child context, its changes are
not persisted to the store.  It saves the changes into the parent context.

These are useful as a temporary context, making isolated change to managed
objects and either discard or save them as needed.

Underlying storage.  out of the box, can store in
  - xml (not in iOS)
  - binary
  - sqlite
  - in-memory

All starts (except sqlite) are loaded into memory all at once.  The
way predicates and fetch requests are run differ.

The in-memory formats are queried via objc, so NSPredicate features that
rely on cocoa features work fine.  Not the case for sqlite b/c all
queries are translated to sql. not that it is not a sqllite wrapper.

Can make a custom store via NSAtomicStore or NSIncrementalStore

You'll be happiest settling that CD is not a db wrapper or a database
itself.  It manages an object graph.  It also manages and validates
bidi relationships, generates a db schema, generates and performs
migrations, and so on.

----------

Entities in the model editor

topics:
- defining entities
- writing and generating NSManagedObject subclasses
- managing relationships
- using fetched properties
- understanding abstract entities

various entity attributes
  - optional - needs to be non-null (indepdent from swift optionality)
  - transient - CD will perform validation and change tracking, but
    property won't be persisted.  (useful for temporary properties,
    or are managed object context-dependent somehow without needing to
    be persisted.  (author hasn't seen much use of it yet)
  - derived (iOS 13+) attributes that derive their value from other attributes
    on the entity.  can reference other properties or follow relationships.
    Can also use functions like canonical/lowercase/uppercase to get
    case/diacritic insneitive etc string value.  @count or @sum for
    a property that represents a set of values. e.g. `cast.@count`
    Current time with now()
    derived attribute is computed once and only recomputed when save or
    explicitly refresh a context.
  - for strings can supply a default value, min/max, regex for validation
  - for values, there's "use scalar type" - controls how property is expected
    to be defined in the managoed object subclasses.  unchecking generates
    an NNSNumber. When checked will use e.g. Double

Transformable data type (robots in the skies)

For when wanting to store properties of an arbitrary type.  Define the
property as transformable. - they're persisted in the underlying store as 
binary data.  The custom type must be representable in objc.

If your transformable property conforms to NSSecureCoding, CD knows
what to do. You _can_ do things like using `[Int]` as the type, but then
you get a huge amount of spew at launch.  le sigh

So, define a custom value transformer.  (ValueTransformer)
Override two methods:
  - transformedValue(_:) for thingie -> Data
  - reverseTransformedValue(_:) for Data -> thingie
  - warning from text, if you subclas NSSecureUnarchiveFromDataTransformer,
    the roles of transformedValue and reverseTransformedValue appear to
    be inverted #facepalm.
  - #lolswift, can't use strong typing or generics, so Any? Any? Any?

something like
```swift
class UIImageTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(
              withRootObject: image,
              requiringSecureCoding: true)
            return data
        } catch {
            print("error transforming image: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            let image = try NSKeyedUnarchiver.unarchivedObject(
              ofClass: UIImage.self, from: data)
            return image
        } catch {
            print("error gnimrofsnart image: \(error)")
            return nil
        }
    }
}
```

before usng need to register it

```swift
        ValueTransformer.setValueTransformer(
          UIImageTransformer(),
          forName: NSValueTransformerName("UIImageTransformer"))
```

and then  provide the transformer to the model by editing in the xcdatamodel
inspector, using UImageTransformer for the Transformer (RitS) and custom
class is UIImage

#sadge - now getting an error because UIKit isn't imported into the 
Movie+CoreDataProperties.swift file. to resolve *that*, need to
manually define the managed object subclas and import UIKit into that.

Can use the the managed object property as if it's a property of the
underlying type.  e.g. `@NSManaged var posterImage: UIImage` - CD will
handle the conversion from and to.  (not necesasrily free/cheap)

So, generating / writing this UIImage enhanced dealie?  
Everything is a NSManagedObject subclassx.  Can use generation,
but can also define by hand.

Selecting an entity, are three codegen options:
  - manual/none
  - class definition (default) - xcrud will keep the managed object subclass
    up to date.
    - can find it by digging around in the derived data, looking for a
      `DerivedSources` folder
  - category/extension

