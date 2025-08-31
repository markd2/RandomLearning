import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
import ActivityKit

struct TattooAttributes: ActivityAttributes {

    // Static state
    var name: String
    
    // Dynamic state
    public struct ContentState: Codable, Hashable {
        var counter: String
    }
}

#endif
