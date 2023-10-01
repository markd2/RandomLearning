//
//  SimplePlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan


class SimpleCaptureModel: ObservableObject {
    var roomCaptureView: RoomCaptureView
    var captureSessionConfig: RoomCaptureSession.Configuration

    @Published var sessionRunning = false

    init(roomCaptureView: RoomCaptureView,
         captureSessionConfig: RoomCaptureSession.Configuration) {
        self.roomCaptureView = roomCaptureView
        self.captureSessionConfig = captureSessionConfig
    }

    func startSession() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfig)
        sessionRunning = true
    }

    func stopSession() {
        roomCaptureView.captureSession.stop()
        sessionRunning = false
    }

    static var shared: SimpleCaptureModel = {
        let roomCaptureView = RoomCaptureView()
        let captureSessionConfig = RoomCaptureSession.Configuration()
        let captureModel = SimpleCaptureModel(roomCaptureView: roomCaptureView,
                                              captureSessionConfig: captureSessionConfig)
        return captureModel
    }()
}

struct SimplePlan: View {
    @StateObject var captureModel: SimpleCaptureModel

    var body: some View {
        VStack {
            Text("Snornge")
            // ContainerForUIView<PlaceholderUIView>()
            ContainerForUIView<RoomCaptureView>(view: captureModel.roomCaptureView)
            HStack {
                Button(captureModel.sessionRunning ? "End Session" : "Start Session") {
                    if captureModel.sessionRunning {
                        captureModel.stopSession()
                    } else {
                        captureModel.startSession()
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    return SimplePlan(captureModel: SimpleCaptureModel.shared)
}
