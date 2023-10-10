//
//  SimplePlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI
import RoomPlan


class SimpleCaptureModel: ObservableObject, NSCoding {
    var roomCaptureView: RoomCaptureView
    var captureSessionConfig: RoomCaptureSession.Configuration

    @Published var sessionRunning = false

    init(roomCaptureView: RoomCaptureView,
         captureSessionConfig: RoomCaptureSession.Configuration) {
        self.roomCaptureView = roomCaptureView
        self.captureSessionConfig = captureSessionConfig
    }

    // The room capture view delegate requires NSCoding (why...)
    // and can't have a required initializer in an extension.
    func encode(with coder: NSCoder) { }
    required init?(coder: NSCoder) { fatalError("why is this NSCoding?") }

    func startSession() {
        roomCaptureView.delegate = self
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

extension SimpleCaptureModel: RoomCaptureViewDelegate {
    // let the user play with it.
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData,
                     error: (Error)?) -> Bool {
        // can save off the opaque raw results of the scan
        return true
    }

    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: (Error)?) {
        let fm = FileManager()
        if let error {
            print("omg error \(error)")
            return
        }
        
        do {
            let documentDirectoryURL = try fm.url(for: .documentDirectory, 
                                                  in: .userDomainMask, 
                                                  appropriateFor: nil, 
                                                  create: true)
            let now = generateCurrentTimeStamp()

            // fails inexplicably - FB13240732 - USDZ details leaking out into the
            // requirements on the file name.
            // let destinationURL = documentDirectoryURL.appendingPathComponent("\(now).usdz")

            // works great
            let destinationURL = documentDirectoryURL.appendingPathComponent("bork-\(now).usdz")
            try processedResult.export(to: destinationURL,
                                       exportOptions: .model)
        } catch {
            // https://developer.apple.com/forums/thread/738801 (awaiting moderation)
            // (sigh) Warning: in SdfPath at line 151 of sdf/path.cpp -- Ill-formed SdfPath </2023_10_02_09_23_23>: syntax error - Coding Error: in _IsValidPathForCreatingPrim at line 3338 of usd/stage.cpp -- Path must be an absolute path: <>

            print("oops no processed result? \(error)")
        }
    }
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
