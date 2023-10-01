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
}

struct ContainerForUIView<T: UIView>: UIViewRepresentable {

    private let view: T

    init(view: T? = nil) {
        if let view {
            self.view = view
        } else {
            self.view = T()
        }
    }

    func makeUIView(context: Context) -> T {
        return view
    }

    func updateUIView(_ uIView: T, context: Context) {
    }
}

struct SimplePlan: View {
    @StateObject var captureModel: CaptureModel

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
    let roomCaptureView = RoomCaptureView()
    let captureSessionConfig = RoomCaptureSession.Configuration()
    let captureModel = CaptureModel(roomCaptureView: roomCaptureView,
                                    captureSessionConfig: captureSessionConfig)
    return SimplePlan(captureModel: captureModel)
}
