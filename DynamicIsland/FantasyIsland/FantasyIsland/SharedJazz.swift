import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
import ActivityKit

struct TattooAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here
        var counter: String
    }

    // Fixed non-changing properties about your activity go here
    var name: String
}

#endif
