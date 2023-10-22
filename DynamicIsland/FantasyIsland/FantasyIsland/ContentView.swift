//
//  ContentView.swift
//  FantasyIsland
//
//  Created by markd on 10/22/23.
//

import SwiftUI
import ActivityKit

struct ContentViewModel {
    // TODO - investigate using the async sequence to get updates.
    let activityAuthInfo = ActivityAuthorizationInfo()
    var canUseLiveActivities: Bool {
        activityAuthInfo.areActivitiesEnabled
    }
    var canPushFrequently: Bool {
        activityAuthInfo.frequentPushesEnabled
    }
}

struct ContentView: View {
    let viewModel = ContentViewModel()
    var body: some View {
        VStack {
            Image(systemName: "airplane")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bozz.  the plane! the plane!!").padding()

            Button("Roark") {
                print("Snorgle")
            }.padding()

            Text(viewModel.canUseLiveActivities ? "Can use live activities" : "No live activities for you")
            Text(viewModel.canPushFrequently ? "Can push frequently" : "No frequent pooshes for you")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
