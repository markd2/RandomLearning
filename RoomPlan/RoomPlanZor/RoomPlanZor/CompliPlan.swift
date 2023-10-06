//
//  CompliPlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan
import RealityKit
import ARKit
import UIKit

class CompliCaptureModel: ObservableObject {

    var arView: ARView
    var captureSession: RoomCaptureSession
    var captureSessionConfig: RoomCaptureSession.Configuration

    // wwdc session had a "visualizer" class for thunking delegate calls through

    @Published var sessionRunning = false
    
    init(arView: ARView, captureSession: RoomCaptureSession,
         captureSessionConfig: RoomCaptureSession.Configuration) {
        self.arView = arView
        self.captureSession = captureSession
        self.captureSessionConfig = captureSessionConfig
    }

    func startSession() {
        captureSession.run(configuration: captureSessionConfig)
        sessionRunning = true
    }

    func stopSession() {
        captureSession.stop()
        sessionRunning = false
    }

    static var shared: CompliCaptureModel = {
        let arView = ARView()
        
        let captureSession = RoomCaptureSession()
        arView.session = captureSession.arSession
        let config = RoomCaptureSession.Configuration()
        let model = CompliCaptureModel(arView: arView,
                                       captureSession: captureSession,
                                       captureSessionConfig: config)
        
        captureSession.delegate = model
        return model
    }()
}

extension CompliCaptureModel: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        print("did update")
    }
    
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        print("did add")
    }
    
    func captureSession(_ session: RoomCaptureSession, didChange room: CapturedRoom) {
        print("did change")
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        print("didRemove")
    }
    
    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        print("didProvide \(instruction)")
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        print("didStartWith")
    }
    
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (Error)?) {
        print("didEndWith")
    }
}

struct CompliPlan: View {
    @StateObject var captureModel: CompliCaptureModel

    var body: some View {
        VStack {
            Text("Greeble")
            ContainerForUIView<ARView>(view: captureModel.arView)
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
    CompliPlan(captureModel: CompliCaptureModel.shared)
}
