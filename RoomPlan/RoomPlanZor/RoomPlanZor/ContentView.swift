//
//  ContentView.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan

struct ContentView: View {
    let captureModel: CaptureModel = {
        let roomCaptureView = RoomCaptureView()
        let captureSessionConfig = RoomCaptureSession.Configuration()
        let captureModel = CaptureModel(roomCaptureView: roomCaptureView,
                                        captureSessionConfig: captureSessionConfig)
        return captureModel
    }()

    var body: some View {
        TabView {
            SimplePlan(captureModel: captureModel)
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