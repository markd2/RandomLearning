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
import SceneKit

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

// scene kit stuff.
// gleefully stolen from https://www.it-jim.com/blog/apple-roomplan-api/

extension CompliCaptureModel {
    func drawBox(scene: RealityFoundation.Scene, dimensions: simd_float3, transform: float4x4, confidence: CapturedRoom.Confidence) {
        var color: UIColor = confidence == .low ? .red : (confidence == .medium ? .yellow : .green)
        color = color.withAlphaComponent(0.8)
        
        let anchor = AnchorEntity()
        anchor.transform = Transform(matrix: transform)
        
        // Depth is 0 for surfaces, in which case we set it to 0.1 for visualization
        let box = MeshResource.generateBox(width: dimensions.x,
                                           height: dimensions.y,
                                           depth: dimensions.z > 0 ? dimensions.z : 0.1)
        
        let material = SimpleMaterial(color: color, roughness: 1, isMetallic: false)
        
        let entity = ModelEntity(mesh: box, materials: [material])
        anchor.addChild(entity);
        
        self.arView.scene.addAnchor(anchor)
    }
}

extension CompliCaptureModel: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        // was in a displatch-async
        DispatchQueue.main.async { [self] in
            arView.scene.anchors.removeAll()
            
            for wall in room.walls {
                self.drawBox(scene: arView.scene, dimensions: wall.dimensions,
                             transform: wall.transform, confidence: wall.confidence)
            }
            
            for object in room.objects {
                self.drawBox(scene: arView.scene, dimensions: object.dimensions,
                             transform: object.transform, confidence: object.confidence)
            }
        }
    }
    
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        print("snorgle did add")
    }
    
    func captureSession(_ session: RoomCaptureSession, didChange room: CapturedRoom) {
        print("snorgle did change")
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        print("snorgle didRemove")
    }
    
    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        print("snorgle didProvide \(instruction)")
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        print("snorgle didStartWith")
    }
    
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (Error)?) {
        if let error {
            print("omg error \(error)")
        }
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
