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
