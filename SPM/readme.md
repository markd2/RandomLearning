# Swift Package Manager

SPM and modular/component architectures have been coming up recently.

Articles from random googling:
  * https://medium.com/dvt-engineering/getting-started-with-microapps-architecture-with-swift-package-manager-spm-63e0113997d2
    - _By utilising Apple's Swift Package Manager, we can achieve application modularisation by splitting our application features into separate independent modules or packages_
    - TootOriole in "toot1" directory.
    - command-control-shift-N to make a new package
    - contents of new empty package:
        - Package.swift, readme.md, Sources/, Tests/
    - be sure to add to target's frameworks/libraries/etc
    - "it demands a test target for every module"
    - bugs:
      - it goes through the hoops of doing ios availability, when it could have
        done     platforms: [.iOS(.v15_0)],
      - "don't worry about error on missing AbstractCoordinator" - did not get that.
      - "delete the storyboard reference as shown below", but there is no below that shows it.
      - no link for the swift book mentioned (Mastering Swift Package Manager - 2021)
        - https://link.springer.com/book/10.1007/978-1-4842-7049-3
        - https://learning.oreilly.com/library/view/mastering-swift-package/9781484270493/


## SPM DSL TLA

* https://docs.swift.org/package-manager/PackageDescription/index.html
  - `import PackageDescription`

* Package
  - name
  - products, array
    - .library
      - name: "Name"
      - targets ["Name"]
  - dependencies
    - .package(url:, from: "1.0.0")
  - targets
    - module or a test suite.
    - targets can depend on other targets in this package, and on products in packages this package depends on
      - target(name:dependencies:)
      - testTarget(name:dependencies:)

