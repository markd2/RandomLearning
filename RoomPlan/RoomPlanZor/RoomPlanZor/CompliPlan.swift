//
//  CompliPlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI

class CompliCaptureModel: ObservableObject {
    @Published var sessionRunning = false

    static var shared: CompliCaptureModel = {
        let model = CompliCaptureModel()
        return model
    }()
}

struct CompliPlan: View {
    @StateObject var captureModel: CompliCaptureModel

    var body: some View {
        VStack {
            Text("Greeble")
            ContainerForUIView<PlaceholderUIView>()
//            ContainerForUIView<RoomCaptureView>(view: captureModel.roomCaptureView)
            HStack {
                Button(captureModel.sessionRunning ? "End Session" : "Start Session") {
                    if captureModel.sessionRunning {
                    } else {
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    CompliPlan(captureModel: CompliCaptureModel.shared)
}
