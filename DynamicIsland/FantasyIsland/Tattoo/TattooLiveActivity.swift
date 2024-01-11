//
//  TattooLiveActivity.swift
//  Tattoo
//
//  Created by markd on 10/22/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TattooLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TattooAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.counter)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.counter)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.counter)")
                    .contentTransition(.numericText())
            } minimal: {
                Text(context.state.counter)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TattooAttributes {
    fileprivate static var preview: TattooAttributes {
        TattooAttributes(name: "World")
    }
}

extension TattooAttributes.ContentState {
    fileprivate static var zeroCount: TattooAttributes.ContentState {
        TattooAttributes.ContentState(counter: "0")
     }
     
     fileprivate static var oneCount: TattooAttributes.ContentState {
         TattooAttributes.ContentState(counter: "1")
     }
}

#Preview("Notification", as: .content, using: TattooAttributes.preview) {
   TattooLiveActivity()
} contentStates: {
    TattooAttributes.ContentState.zeroCount
    TattooAttributes.ContentState.oneCount
}
