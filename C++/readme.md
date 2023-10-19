# C++

because, why not %-)

### Linkage

* https://en.cppreference.com/w/ - C++ Reference (ooh, also has a C reference)
* https://en.cppreference.com/w/cpp/language/operator_precedence - operator precedence
* https://learning.oreilly.com/library/view/discovering-modern-c/9780136798477/app03.xhtml#secC_2 - annotated operator summary

### Bookage

* Discovering Modern C++ 3rd edition, Peter Gottschling (https://www.amazon.com/gp/product/0136677649 | https://learning.oreilly.com/library/view/discovering-modern-c/9780136798477/preface.xhtml#secP_5)

### Talkage

See talks over in Interesting Talks in this repo.

To consume (recommendations from the book):
* https://www.youtube.com/watch?v=PVYdHDm0q6Y (Hourglass APIs)
* via Liscio - https://eigen.tuxfamily.org/dox/TopicInsideEigenExample.html - template beauty

### Randomage

```
[[nodiscard]] int read_matrix_file(blah)
```
* [[nodiscard]] can also apply to types, so `struct [[nodiscard]] ErrorType {};`, if that's used as a return type, the compiler will warn if it's discarded.  (Can also apply to constructors)
  - can also apply a message `[[nodiscard("Lock objects should never be discarded")]]`

* `noexcept` for a function that cannot throw.
* `static_assert` for checking assertions at compile time
* `endl` flushes the buffer
* iostream formatting, e.g. `<< setprecision(16)`, `<< setw(30)`, `<< hex`, etc
  - c++20 introduces a `<format>` library
  - not fully implemented it seems?  https://libcxx.llvm.org/Status/Format.html
* can set exception throwing from iostream
  - e.g. `cout.exceptions(ios_base::badbit | ios_base::failbit);`
* `std::number::pi` from `<numbers>`
* `<filesystem>` has file system stuff (like directory enumeration, copy files, make links...)
* `nullptr` is modern NULL.  `int* ip4{}` makes the pointer null out of the gate.
* Shmart Pointers. Come from `<memory>`
    - `unique_ptr` - unique ownership of the referred data.  use like an ordinary pointer. Memory is released when the pointer expires
        - `uniq_ptr<double> dp{new double};`
        - therefore needs dynamic memory
        - cannot copy `dp2 = dp`
        - can move to another unique_ptr.  `dp3 = move(dp)`, and the move-froms get set to `nullptr`
        - no overhead over raw pointers
        - can also provide a deleter. e.g.
        - `std::unique_ptr<FILE, decltype([](FILE *f) { fclose(f); })>;`
    - `shared_ptr` - manages memory shared between multiple parties
        - memory relased as soon as no shared ptr is referring to the data
        - a `shared_ptr` can be copied as often as desired
        - can ask for its `use_count()`
        - if possible, use `make_shared` to make a shared ptr
              - `shared_ptr<double> p1 = make_shared<double<();`
              - the refcount and the data are stored together
    - `weak_ptr`  for breaking cyclic references
    - `auto_ptr` - don't use. "generally considered as a failed attempt on the way to unique_ptr"
* `reference_wrapper` - "behaves similarly to references but avoids some of their limitations, like it can be used in containers"
* "pointers should only be used when dealing with dynamic memory"
* Initialize vectors with initializer lists
  - std::vector<float> v = {1, 2, 3};
* `valarray` (value arrays), can slice them
* `#pragma once` rather than include guards
* c++20 introduces a macro for each language feature introduced since C++11, like `__cpp_modules` for module support
    - the value is the year/month when the feature was added to the draft
* Herb Sutter and Andrei Alexandrescu phrased the distinction nicely: when you establish a new abstraction, make all internal details private; and when you merely aggregate existing abstractions, the data members can be public [66, Item 11].
* A constructor is a member function with the same name as the class itself
* Can delete implicitly generated functions, like this hypothetical better Fopen:
```
using FilePtr = std::unique_ptr<FILE, decltype([](FILE *f) { fclose(f); })>;
[[nodiscard]] FilePtr fopen(const std::filesystem::path &path,
                            std:string_view mode);
//(this can be called with fopen("mode", "/path/path") because of implicit conversions)
void fopen(const auto &, const auto &) = delete;
// this will prevent calls from implicitly converted things. (I think this const auto is an 'implicit template'?)
```

### From AoC

Doesn't seem to be a `split`, but stringstreams come close for space-delimited ones.

```
        std::stringstream ss(line);
        std::string opponent, player;
        ss >> opponent;
        ss >> player;
```

`enum class` - namespaced enums.  Doesn't allow methods like in swiftland.

```
enum class Outcome {
    Win,
    Lose,
    Draw
};
```

----------

# Swift/C++ Interop

## WWDC Session

* Mix C++ and Swift (WWDC 2023) - https://developer.apple.com/videos/play/wwdc2023/10172/

"adopt swift in even more places"

- If have a large C++ codebase, do bidirectional interop.
- Can remove objc bridging layer.

Let's see how easy it is to adopt.

structure of sample app:

- Image processing framework, and UI code
- Image processing is in C++.  used objc++ for UI
- now allow users to pick a few images from camera roll.  SwiftUI has
  a photo picker.
- luckily with xcrud 15, can eassiy adopt swift in objc++ codebase and
  easy access to C++ APIs
- add swift file to the project
- because the frameworks are pulled in automagically, don't need a 
  bridging header
- need to add C++ Interop in build settings (to C++/obj-C++) can call
  APIs from C++ image framework
- in swift file, import framework like any other module
- can command-clikc on module name to see its contents.
  - shows the C++ converted APIs.

CXXImageENgine imported as an unsafe pointer -get to it later.
  - has two methods load and get images

Drop in the UI for photo picker, and focus on the two C++ methods.

Grab the shared `CxxImageEngine.shared.pointee.loadImage(blah)`
- 'this is super easy'

Can import the generated header - all public swift APIs.
Can call swift code in C++.

construct the swiftUI view `SampleApp::ImagePakc::init().present(slef)`

Run on the device. - yay

This is true bidriectional interoperability.  Use C++ tpes and functions
in swift, and viceversa.  in C++ could construct a swiftUI view, whose
body called back into the C++ framework.  No bridging layer. And all
APIs are direct - no overhead.

This is with a small app. The Swift compiler can support it in large and
complex code bases.

* import most collections - stdlib and elsewhere
* function templates and class template specialiations
* smartpointers - std::shared_ptr, and user-defined
  (ah, it knows about shared ptr, but not unique pointer)
  can apply powerful optimizations
* expose most swift APIs, structs, coasses, enums, and members, and
  can expose generic tpes liei array and string, and resilient structs
  and classes.
* fully supported by xcrud - code completion, jump to definitnon global rename,
  and debugging.
* Big List of Supported APIs slide:
  - std::vector
  - swift::Array
  - structs and classes
  - reference types
  - functions and methods
  - namesapces
  - enums
  - code completion
  - std::sset
  - function templates
  - class templates specialization
  - jump to definition
  - type alias
  - std::shared_ptr
  - operators
  - collections and dictionaries
  - protocol conformance
  - debugger support

The swift compiler supports large codebases that use these APIs and more,
cohesive experience across languages, adopt swift in even more places.

Basics covered, dive deeper into natural swift APIs, make your C++ apis
feel natural and safe in swift.

swift compiler can automatically import most C++ APis and represent them
as safe swift APIs (=> is an export with swift annotations).

* getters and setters -> methods => swift computed property
* value types -> structs
* reference types -> pointers  => Foreign Reference Type
* operators -> operators
* unsafe methods -> not imported  => methods
* containers -> Swift collections
* constructos -> initializers
(and more)

The compiler allows to fine-tuned how APis are imported. and expose even
more natural-feeling APIs.

Providing compiler more info using annotations.

e.g. might use a C++ naming convention
```
int getValue() const SWIFT_COMPUTED_PROPERTY;
void setValue(int newValue) SWIFT_COMPUTED_PROPERTY
  - renames to -
var value: Int { get set }
```

can also add argument labels, etc.

Can also explain high-level patterns like reference semantics

```
struct SWIFT_SHARED_REFERENCE(retain, release) CxxReferenceType
  - renames to `
class CxxReferenceType
```

or correct swift if it thinks an api is unsafe even if it's actually fine

```
SWIFT_RETURNS_INDEPENDENT_VALUE
std::string_view networkName() const;
  - renames to -
func networkName() -> std.string_view
```

Also want a swift UI safe button to save back to library.

Back to swift, can look at APIs imported., via getImages.
Returns a std.vector<Image, allocator<Image>>

The details of std.vecotr

Swift types : value (struct) and reference types (class).

By C++ types will be imported as value types.  So will import vector
as a value type.  The only difference between vecotr and other swift
struct, it'll use its types special members (like copy constructor) to
manage lifetime. Thye often perform deep copies - swift is copied when
modified. When it copies the vector, it calls all the elements.

can iterate and convert

```
static func saveImages() {
    for image in CxxImageEngine.shared.pointee.getImages() {
        let uiImage = CxxImageEngine.shared.pointee.uiImageFrom(image)
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
```

This for-loop works because it has begin/end methods, so will automatically
import it as a collection.

This auto-conformance to collection makes it convertable to a swift array.
Plus get map and filter.

Use the swift collection apis instead of iterator - which don't fit into
swift's safety model.

The compiler blocks getting the iterator functions.

We're reminded as an unsafe pointer - in both swift and C++. b/c the type
has "reference semantics" - object identity, and copies will be 
references to same memory.

objc also has a clear distinction, which makes mapping in objc easy. C++ not
as clear what types go into what category - by default will import
everything as a value type. Can also import thing as reference / class
types by adding an annotation.  `SWIFT_SHARED_REFERENCE(retain, release)`
will enforce will always passed as a pointer / reference, and removes
unsafePointer indirection.  Swift will mange the lifetime with custom
retain and release operations.  

You'll need to provide the retain./release functions.

import <swift/bridging> to bring in swift shared reference

get some swift errors about dereferencing the pointer.

in the for loop calling getImaged, defining a getter and setter is pretty
common pattern, but doesn't feel natural. Use another annotation.
SWIFT_COMPUTED_PROPERTY applied to getter and setter into a swift computed
property.  

THere are many other annotations:
- customize imported APIs
- #import<swift/bridging>
- self-contained
- returns independent value
- swift name
- shared reference
- immortal reference
- unsafe reference
- conforms to protocol
- swift computed property

Supported on all apple platforms, and leenux and windows

C++ is large and complex, and evolve based on your feedback
when we change the way things are import, create a new version of interop,
can opt-in with changes

There's a C++ interopreability workgroup in the open source.
  - https://www.swift.org/cxx-interop-workgroup/

Wrote two documents that guide the process


----------

## Swift.org docs

Mixing Swift and C++

* https://www.swift.org/documentation/cxx-interop/
* https://www.swift.org/documentation/cxx-interop/status/ - supported features
* https://fossies.org/linux/swift-swift/lib/ClangImporter/bridging - bridging macros
* https://www.swift.org/cxx-interop-workgroup/
* https://github.com/apple/swift/blob/main/docs/CppInteroperability/GettingStartedWithC%2B%2BInterop.md
* https://www.swift.org/documentation/cxx-interop/project-build-setup/
* https://developer.apple.com/documentation/swift/mixinglanguagesinanxcodeproject - mixing languages sample
* https://developer.apple.com/documentation/swift/callingapisacrosslanguageboundaries - calling apis across language boundaries sample

* "please discuss in swift formus" https://forums.swift.org/c/development/c-interoperability/

Enabling Interop:
  - C/objc interop by default
  - must enable C++ to C++ -> Swift or expose swift -> C++

Mixed-language projects
  - https://www.swift.org/documentation/cxx-interop/project-build-setup/#mixing-swift-and-c-using-swift-package-manager
  - SPM
    - does not support using Swift in C++
    - so just C++ -> Swift
    - Enabling interop (that .interoperabilityMode thing)
```
let package = Package(
    name: "LibraryThatUsesCxx",
    products: [
        .library(
            name: "libraryUsesCxx",
            targets: ["libraryUsesCxx"])
    ],
    targets: [
        .target(
            name: "libraryUsesCxx", 
            swiftSettings: [.interoperabilityMode(.Cxx)])
    ]
)```
    - Swift imports C++ headers using *Clang* modules
      - https://clang.llvm.org/docs/Modules.html (this is a novel)
      - https://www.swift.org/documentation/cxx-interop/#importing-c-into-swift
      - "provide a more robust and efficient semantic model of C++ headers
         compared to the preprocessor-based model of direclty including
         the contents of header files using #include"
      - legit C++ modules (C++20) cannot be imported
      - for swift to import a clang module, needs to find a `module.modulemap`
        - describles how a pile of C++ headers maps to a clang module
        - SPM automatically generates when it finds an umbrella header
        - xcrud automatically generates for a framework target
        - otherwise, make it manually
        - list all the header files from a c++ target to be visible in swift
        - also `export *` - ensures that the types from clang modules imported
          into the module are made visible to swift as well
        - place the module map as a peer of the re45tdsxe (Bob says) headers
          in the include directory
      - with a module map, swift can import it when interop is enabled
      - build system needs to -I the blah/include directory
      - https://clang.llvm.org/docs/Modules.html#module-map-language
        - "not guaranteed to be stable between major revisions of clang"
        - can break things into smaller modules - like put errno.h into
          its own module.
        - (didn't even skim)
    - Swift enumeratiin used internally by the compiler to represent C++ enums
    - Swift structure used internally to represent classes
    - Swift uses C++ types and calls C++ functions directly, wihtout any
      indirection or thunking.

Exposing Swift APIs to C++




Working with imported C++ APIs

- C++ types and functions are presented as if they were swift types 
  and functions
  - looks like no names unless use SWIFT_NAME
  - structs/classes (which are actually nearly the same in C++)
    come in as struct types by default and are value types
    - always copied
    - can mark mutating memberfunctions with SWIFT_MUTATING
    - If there's a copy constructor, Swift will use it when
      a value is copied.  Same with destructors
    - C++ deleted copy constructors are not availble in swift
      - non-copyable but have a move consstructor will be available
        in the future
    - types passed around with a pointer or a reference, might not
      make sense to map them to value types - can be annotated to
      map to reference types instead.
  - public constructors (that aren't copy/move) become initializers
  - public data members become properties
  - member functions become methods
    - constant member functions are `nonmutating`
    - unannotated member functions are `mutating`
  - consnt member functions must not mutate the object
    - the compiler makes assumptions about const member functions
      - could cause swift to not observing the mutation of the instance
  - member functions returning references are unsafe by default
    - including pointers, and objects that contain references or
      pointers)
    - they're often returning pointers inside of `this`
      - so if the outer object goes away...
    - swift renames: prefexed with two underscores and suffex with unsafe
    - e.g. `const Tree &getRootTree() const { ... }` becomes __getRootTreeUnsafe
  - c++ allows member functions tobe overloaded based on `const`
    - they both become methods
    - swift renames the mutating method to avoid having two ambiguious
      methods with same name and arguments
    - adds a `Mutating` suffix
  - virtual member functions not available in Swift
    - that's kind of a big limitation...
     -  'blah()' is unavailable: virtual functions are not yet available in Swift
   - the rest of the class is available, just not the virtual member functions.




Not supported
  - C++ structs/classes with a deleted copy constructor
    - except those that have been explicitly mapped to Swift reference types
      - c.f. https://www.swift.org/documentation/cxx-interop#mapping-c-types-to-swift-reference-types
  - std::unique_ptr, std::function, std::variant
  - C++ class and structure templates not directly available in swift
    - the instantiated specializations fo a class or structure are
    - can use a type alias defined in a C++ header 
      - https://www.swift.org/documentation/cxx-interop#using-class-templates
  - thrown exceptions not caught by C++ code and reaches swift-land Abends
  - importing legit C++ modules (C++20)

Known issues:
  - https://github.com/apple/swift/issues/66159

Packages:
  - a swift target with C++ interop in SPM requires its dependencies
    to also enable C++ interop as well.
    - issue for the constraint: https://github.com/apple/swift/issues/66156

Performance:
  - swift can make a deep copy of a collection in a for-in loop
    - issue: https://github.com/apple/swift/issues/66158

Enabling C++ interop in an existing codebase that imports and uses C/objc
APIs in swift could cause some source breakages in swift _(uh...)_
  - like keyword collision
  - existing C/objc might try to import another clang module inside of
    an extern"C", not allowed in C++ mode
  - fix the headers
  - might have ambiguity errors with C std library with jazz in the C++
    library.
    - can address with an explicit module qualifier from swiftland

Annotation macros:
  - SWIFT_COMPUTED_PROPERTY, even for just getters
  - SWIFT_SHARED_REFERENCE
    - AH HA: `} SWIFT_SHARED_REFERENCE(forestRetain,forestRelease);`
  - SWIFT_IMMORTALT_REFERENCE - things allocated and leaked without tracking their uses.
    - also arena-allocated, thign is aren't individually managed
    - imported as unmanaged classes
      - for an arena-allocated dealie, it's unsafe, but unavoidable
                    

--------------------------------------------------

Experiments.

Simplest possible:
  - https://github.com/apple/swift/blob/main/docs/CppInteroperability/GettingStartedWithC%2B%2BInterop.md#creating-a-module-to-contain-your-c-source-code


`let larch = Tree()` : 'init()' is deprecated: This zero-initializes the backing memory of the struct, which is unsafe for some C++ structs. Consider adding an explicit default initializer for this C++ struct.


Apple sample code

* Swift-and-Cplusplus-mixed-framework
   - a framework has cpp and swift back and forth
   - include the C++ headers in the framework umbrella header
     - Don't forget to make them public!!

* Swift-and-Cplusplus-interop-showcase
   - "Use a variety of C++ APIs in Swift -- and vice-versa -- across multiple targets and frameworks in an Xcode project."
   - looks like a number of frameworks:
     - main app - pure swift
     - forest - pure c++, includes IntrusiveRefCounted.hpp
     - ForestBuilder - swift and objc++
     - forestUI - pure swift
     - forestTestSupport - adding equitable to a C++ class
     - forestTestSupportTests - tests
  - IntrusiveRefCounted (love the name)
    - there's a "forestRetain" and "forestRelease" - how does it know
      to use those?
  - Exposing a specialization of a vector
    - `using VectorOfTrees = std::vector<Tree>;`
    - kind of got beaten using a vector of swift types
      - inside the same framework, looks like circular includes
      - using a pointer to the swift type was fine
      - trying to pull the multi-langauge framework into the pure-C++
        library was giving objc(++) compiler problems. Which I'd like to
        paste here, but xcode decided to stop hanging on to build logs (!)
  - SWIFT_COMPUTED_PROPERTY, even for just getters
    - annotating a setting automatically makes a getter, so no write-only
      properties.
  - SWIFT_SHARED_REFERENCE
    - AH HA: `} SWIFT_SHARED_REFERENCE(forestRetain,forestRelease);`
    - allows Swift to reference it as a reference-counted reference type
    - reference-counted types that are passed around by pointer or reference in C++
      - either have retain/release opertions that inc/dec a reference count  
        stored intrusively in the object, or non-intrusively with a 
        shared pointer type like std::shared_ptr
    - the macro expects two arguments / retain and release function
      - take one arg, return void, arg is pointer to the type (not a base type)
    - imported as a reference type
    - no example shared_ptr in the apple samples.
  - SWIFT_UNSAFE_REFERENCE - like immportal, but it communicates different
    semantics - this type is intended to be used unsafely rather than
    living for the duration of the proogram
    - the programmer must validate that any reference to such an object
      is valid themselves.
    - the macro is _identical_ to immportal
  - SWIFT_RETURNS_INDEPENDENT_VALUE - added to C++ member functions to let
    Swift know that it doesn't return a dependent reference or a dependent
    view
    - basically you're not returning an interior reference value.
    - like a "const char *getName() const" - if it's returning a static
      string, then it should be marked as returning an independent value.
      But if you extract a char* from a std::string, then don't use this.
  - SWIFT_SELF_CONTAINED - it's not a view type.  All member functions
    that return the self contained type are assumed to be safe in Swift
    - a.k.a. owns and controls the lifetime of all of the objects it references
    - allows swift to import methods that return a class or struct type that's
      annotated thusly
  - SWIFT_NAME - providing a different name for C++ types and functions
    in swift
    - e.g. `class Error {...} SWIFT_NAME("CxxLibraryError");`
    - and `void sendCopy(const std::string &) SWIFT_NAME(send(_:));`
  - SWIFT_CONFORMS_TO (swift.org only talks about template specialization,
    but the header seems to imply that non-template works as well)
    - conform all specializations of a class template to
      a swift protocol automatically.
    - makes all specialiations conform to a protocol.
    - makes it possible to add functionality to all specializations of
      a class template in Swift by using a protocol extension
    - also lets you use any specialization in constrainted generic code witout
      explicit conformances
  - SWIFT_MUTATING
    - specifies that a specific _constant_ C++ member function should be
      imported as a mutating Swift method.
