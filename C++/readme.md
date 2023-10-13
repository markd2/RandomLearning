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

Mixing Swift and C++

* https://www.swift.org/documentation/cxx-interop/
* https://www.swift.org/documentation/cxx-interop/status/ - supported features

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

Working with imported C++ APIs

- C++ types and functions are presented as if they were swift types 
  and functions




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
