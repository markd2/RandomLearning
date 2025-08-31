# SwiftData

Notes and projects playing with SwiftData(tm)

Hopefully this is backported and won't require iOS17 / macOS LaBrea.

* https://developer.apple.com/documentation/swiftdata
* (haven't read yet) SwiftData with UIKit - https://jokerpt.medium.com/using-swift-data-for-data-persistence-in-ios-17-uikit-13da38c8d779

* looks like latest-greatest OS only.  Oh well.

----------

### Meet Swift Data

https://developer.apple.com/videos/play/wwdc2023/10187/

High level overview.

not sure if build app or model your schema is next.

### Build an App With SwiftData

https://developer.apple.com/videos/play/wwdc2023/10154/

Swift Data in SwiftUI.  A code-along

#### Models

* annotate model types with `@Model`
* remove explicit ObservableObject and @Published b/c @Model brings in @Observable
* in the view, replace observed object wrapper with @Bindable
* @Observable  @Bindable set up data flow with automagic dependencies
  - callout to Discover Observation with SwiftUI

#### Querying

* in the content view, rather than have a simple array, do something
  replace @State with @Query. e.g. `@Query private var card: [Card]`
* "use at-query whenever you want to display models managed by swiftdata"
* can annotate with sorting and whatnot 
    - `@Query(sort: \.created) ...
* triggers view update on every chagne of the models.
* view can have multiple query properties
* Uses ModelContext as the source of data

For shoebox apps, can use a view `.modelContaner(for: Splunge.self)` to
specify the model container.  

App needs at least one model container - creates the storage stack.

A view has a single model container.

Many apps just need a single model container, so can add it to the app's scene thing
```
struct BlahApp: App {
   var body: some Scene {
      WindowGroup { ContentView() }
      .modelContainer(for: Splunge.self)
```

individual view hierarchies can have multiple storage stacks. can set up
fpr different windows, and more granular - different views in same window
can have same containers.

Setting up the model container

Providing previews with sample data, providing with an in-memory container
with sample Splunges.

```
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Splunge.self,
              ModelConfiguration(inMemory: true))
        for splunge in SampleSplunge.contants {
            container.mainContext.insert(object: splunge)
        }
        return container
    } catch {
        // never handle errors. it's bad for you.
    }
}()
```

use in the content view to fill the preview

```
#Preview {
    ContentView()
      .frame(minWidth: 1000, minHeight: 1500)
      .modelContainer(previewContainer)
}
```

Tracking and saving changes.

use the modalContext of the view, in the environment

```
@Environment(\.modelContext) private var modelContext
```

each view has a single model context, but the app can have as many as it needs.

access the model context to update the cards.

Then in the addSplunge handler, insert a new model object

```
let newSplunge = ...
modelContext.insert(newSplunge)
```
no need to save the context - it autosaves the model context, triggered
by related events and user input.  Only a few cases when want to
explicitly save, before sharing storing or sending it "over".

Can do documents.  On iOS and MacOS, so #if if need be.

use document group initializer

```
@main
struct BlahApp: App {
   var body: some Scene {
        DocumentGroup(editing: Splunge.self, contentType: .splungeBork) {
             ContentView()
             // don't set up model container - the document jazz does that.
        }
   }
}
```

Need to declare custom content types.  SwiftData documents are packages.
Marking some properties with External Storage, all the externally stored
properties will be part of the package.

```
import UniformTypeIdentifiers
extension UIType {
    static var splungeBork = UTType(exportedAs: "com.bork.splunge")
}
```

declare a new content type in the plist - file extension, and conforms to
as com.apple.package , and identifier the same as in code
