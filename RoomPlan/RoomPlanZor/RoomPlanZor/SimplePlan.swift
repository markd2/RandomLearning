//
//  SimplePlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan


//  When you want your view to coordinate with other SwiftUI views,
//  you must provide a Coordinator instance to facilitate those
//  interactions. For example, you use a coordinator to forward
//  target-action and delegate messages from your view to any SwiftUI
//  views.

class CaptureModel: ObservableObject {
    var roomCaptureView: RoomCaptureView
    var captureSessionConfig: RoomCaptureSession.Configuration

    var sessionRunning = false

    init(roomCaptureView: RoomCaptureView,
         captureSessionConfig: RoomCaptureSession.Configuration) {
        self.roomCaptureView = roomCaptureView
        self.captureSessionConfig = captureSessionConfig
    }

    func startSession() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfig)
    }

    func stopSession() {
        roomCaptureView.captureSession.stop()
    }
}

struct PlaceholderContainerView: UIViewRepresentable {

    func makeUIView(context: Context) -> PlaceholderUIView {
        return PlaceholderUIView()
    }

    func updateUIView(_ uIView: PlaceholderUIView, context: Context) {
        print("update ui view \(context)")
    }
}

struct SimplePlan: View {
    @StateObject var captureModel: CaptureModel

    var body: some View {
        VStack {
            Text("Snornge")
            PlaceholderContainerView()
            HStack {
                Button(captureModel.sessionRunning ? "End Session" : "Start Session") {
                    captureModel.sessionRunning.toggle()
                }
            }
        }
    }
}

#Preview {
    let roomCaptureView = RoomCaptureView()
    let captureSessionConfig = RoomCaptureSession.Configuration()
    let captureModel = CaptureModel(roomCaptureView: roomCaptureView,
                                    captureSessionConfig: captureSessionConfig)
    return SimplePlan(captureModel: captureModel)
}
