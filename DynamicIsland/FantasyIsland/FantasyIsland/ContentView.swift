//
//  ContentView.swift
//  FantasyIsland
//
//  Created by markd on 10/22/23.
//

import SwiftUI
import ActivityKit

class ContentViewModel {
    // TODO - investigate using the async sequence to get updates.
    let activityAuthInfo = ActivityAuthorizationInfo()
    var canUseLiveActivities: Bool {
        activityAuthInfo.areActivitiesEnabled
    }
    var canPushFrequently: Bool {
        activityAuthInfo.frequentPushesEnabled
    }
    
    private var errorMessage = ""
    
    private func setup(withActivity: Activity<TattooAttributes>) {
        print("no idea wtf goes here")
    }

    func goLive() {
        guard canUseLiveActivities else { return }

        do {
            let tattoo = TattooAttributes(name: "Splunge")
            let initialState = TattooAttributes.ContentState(emoji: "Greeble")
            let activity = try Activity.request(
              attributes: tattoo,
              content: .init(state: initialState, staleDate: nil),
              pushType: .token)
            setup(withActivity: activity)
        } catch {
            errorMessage = "can't start \(error)"
            print(errorMessage)
            print(error.localizedDescription)

        }
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
                viewModel.goLive()
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
