//
//  ContentView.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan

enum Tab: Hashable {
    case simplePlan
    case complicatedPlan
    case multiPlan

    var id: Self { self }
}

struct ContentView: View {
    @State private var tab = Tab.simplePlan

    var body: some View {
        TabView(selection: $tab) {
            SimplePlan(captureModel: SimpleCaptureModel.shared)
              .tabItem {
                  Label("Simple Plan", systemImage: "house")
              }
              .tag(Tab.simplePlan)
            CompliPlan(captureModel: CompliCaptureModel.shared)
              .tabItem {
                  Label("Complicated Plan", systemImage: "house.circle.fill")
              }
              .tag(Tab.complicatedPlan)
            MultiPlan()
              .tabItem {
                  Label("Multi Plan", systemImage: "house.lodge")
              }
              .tag(Tab.multiPlan)
        }
        .buttonStyle(.borderedProminent)
    } 
}

#Preview {
    ContentView()
}
