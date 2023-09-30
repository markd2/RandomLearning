//
//  ContentView.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SimplePlan()
              .tabItem {
                  Label("Simple Plan", systemImage: "house")
              }
            MultiPlan()
              .tabItem {
                  Label("Simple Plan", systemImage: "house.lodge")
              }
        }
    }
}

#Preview {
    ContentView()
}
