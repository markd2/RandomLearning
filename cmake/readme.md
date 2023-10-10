# CMAKE

"The Modern CMake" is 3.15.  Get help at https://cmake.org/cmake/help/ / https://cmake.org/cmake/help/latest/ . There's also a tutorial off of there.

----------

Looking at "Modern CMake For C++" _(oh no make it stop please hurt me)_
from Packt (via O'Reilly)

From the Packt book.
This is 

Minimal CMakeLists.txt (in same directory as hello.cpp)

```
cmake_minimum_required(VERSION 3.20)
project(Hello)
add_executable(Hello hello.cpp)
```

make the make make via

```
% cmake -B buildtree
```

the buidltree directory (peer of the cmakelists.txt file) 

which is a redonkulous amount of stuffs:

```
├── CMakeCache.txt
├── CMakeFiles
│   ├── 3.27.6
│   │   ├── CMakeCCompiler.cmake
│   │   ├── CMakeCXXCompiler.cmake
│   │   ├── CMakeDetermineCompilerABI_C.bin
│   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   ├── CMakeSystem.cmake
│   │   ├── CompilerIdC
│   │   │   ├── CMakeCCompilerId.c
│   │   │   ├── CMakeCCompilerId.o
│   │   │   └── tmp
│   │   └── CompilerIdCXX
│   │       ├── CMakeCXXCompilerId.cpp
│   │       ├── CMakeCXXCompilerId.o
│   │       └── tmp
│   ├── CMakeConfigureLog.yaml
│   ├── CMakeDirectoryInformation.cmake
│   ├── CMakeScratch
│   ├── Hello.dir
│   │   ├── DependInfo.cmake
│   │   ├── build.make
│   │   ├── cmake_clean.cmake
│   │   ├── compiler_depend.make
│   │   ├── compiler_depend.ts
│   │   ├── depend.make
│   │   ├── flags.make
│   │   ├── link.txt
│   │   └── progress.make
│   ├── Makefile.cmake
│   ├── Makefile2
│   ├── TargetDirectories.txt
│   ├── cmake.check_cache
│   ├── pkgRedirects
│   └── progress.marks
├── Makefile
└── cmake_install.cmake
```

Then build with

```
$ cmake --build buildtree
```

And then can run the executable:

```
% ./buildtree/Hello 
Bork Bork
```

There's some docker stuff the book getd in to pretty early.
This snack overflow has some docker stuff: https://stackoverflow.com/a/49719638

But might not work on M1s...  And doesn't.  Will see if I can get by
without docker for the book.

There are FIVE executables:

* cmake - main one that configures, generates, and builds projects
* ctest - test driver to run and report test results
* cpack - (and abednego) packing program to make installers and source packages
* cmake-gui - wrapper around cmake
* ccmake - console gui wrapper around cmake

Cmake has a few modes of operation:
* generate a project buildsystem
* building the project
* installing the proejct
* running a script
* running a CLI too
* getting help

CMake supports for out-of-source builds / production of (wondrous)
artifacts in a seperate directory.  This keeps the source directory clean.

Can do

* `cmake -S path-to-source -B path-to-build`, or if you're in a source tree
  can do `cmake -B path-to-build`

Don't do a naked `cmake` - it'll use the current directory, making an
in-source build "and that is messy - NOT RECOMMENDED"


