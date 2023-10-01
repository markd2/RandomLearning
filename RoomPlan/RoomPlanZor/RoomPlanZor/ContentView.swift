//
//  ContentView.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan

struct ContentView: View {
    var body: some View {
        TabView {
            SimplePlan(captureModel: SimpleCaptureModel.shared)
              .tabItem {
                  Label("Simple Plan", systemImage: "house")
              }
            CompliPlan(captureModel: CompliCaptureModel.shared)
              .tabItem {
                  Label("Complicated Plan", systemImage: "house.circle.fill")
              }
            MultiPlan()
              .tabItem {
                  Label("Multi Plan", systemImage: "house.lodge")
              }
        }
    }
}

#Preview {
    ContentView()
}
