//
//  ContentView.swift
//  FantasyIsland
//
//  Created by markd on 10/22/23.
//

import SwiftUI
import ActivityKit

class ContentViewModel: ObservableObject {
    // TODO - investigate using the async sequence to get updates.
    let activityAuthInfo = ActivityAuthorizationInfo()
    @MainActor var canUseLiveActivities: Bool {
        activityAuthInfo.areActivitiesEnabled
    }
    var canPushFrequently: Bool {
        activityAuthInfo.frequentPushesEnabled
    }
    
    private var errorMessage = ""
    private var timer: Timer?
    @Published var count = 0
    @Published var splunge = ""

    var currentActivity: Activity<TattooAttributes>?
    
    private func setup(withActivity activity: Activity<TattooAttributes>) {
        currentActivity = activity
    }

    func stopIt() {
        Task {
            guard let currentActivity  else { return }
            
            let finalContent = TattooAttributes.ContentState(counter: "666")

            await currentActivity.end(
                ActivityContent(state: finalContent,
                    staleDate: nil),
                dismissalPolicy: .default)
            timer?.invalidate()
            timer = nil
            count = 0
            self.currentActivity = nil
        }
    }

    @MainActor func goLive() {
        guard canUseLiveActivities else { return }

        stopIt()
        
        do {
            let tattoo = TattooAttributes(name: "Splunge")
            let initialState = TattooAttributes.ContentState(counter: "0")
            
            let content = ActivityContent(
                state: initialState,
                staleDate: nil,
                relevanceScore: 0.0)
            
            let activity = try Activity.request(
                attributes: tattoo,
                content: content,
                pushType: nil)
            
            setup(withActivity: activity)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                         repeats: true) { timer in
                print("lub dub")
                self.update(alert: false)
                self.count += 1
            }

Task {
    for await state in activity.activityStateUpdates {
        self.splunge = "\(state)"
    }
    print("bye bye")
}
        } catch {
            errorMessage = "can't start \(error)"
            print(errorMessage)
            print(error.localizedDescription)
        }
    }

    func update(alert: Bool) {
        guard let activity = currentActivity else {
            return
        }
        Task {
            print("updating")
            var alertConfig: AlertConfiguration? = nil
            let contentState: TattooAttributes.ContentState
            if alert {
                alertConfig = AlertConfiguration(
                    title: "Splunge \(count)",
                    body: "Greeble",
                    sound: .default
                )
               contentState = TattooAttributes.ContentState(
                    counter: "!\(count)¡")
             } else {
                contentState = TattooAttributes.ContentState(
                    counter: "\(count)")
            }

            await activity.update(
                ActivityContent<TattooAttributes.ContentState>(
                    state: contentState,
                    staleDate: Date.now + 15,
                    relevanceScore: 0
                ),
                alertConfiguration: nil
            )
        }
    }

}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "airplane")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bozz.  the plane \(viewModel.count)! the plane!!").padding()

            Button("Roark") {
                print("huh")
                if viewModel.currentActivity == nil {
                    viewModel.goLive()
                } else {
                    viewModel.stopIt()
                }
            }.padding()

            Text(viewModel.canUseLiveActivities ? "Can use live activities" : "No live activities for you")
            Text(viewModel.canPushFrequently ? "Can push frequently" : "No frequent pooshes for you").padding()

            Text(viewModel.splunge)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
