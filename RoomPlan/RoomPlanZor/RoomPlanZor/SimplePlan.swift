//
//  SimplePlan.swift
//  RoomPlanZor
//
//  Created by markd on 9/30/23.
//

import SwiftUI



//  When you want your view to coordinate with other SwiftUI views,
//  you must provide a Coordinator instance to facilitate those
//  interactions. For example, you use a coordinator to forward
//  target-action and delegate messages from your view to any SwiftUI
//  views.

struct PlaceholderContainerView: UIViewRepresentable {

    func makeUIView(context: Context) -> PlaceholderUIView {
        return PlaceholderUIView()
    }

    func updateUIView(_ uIView: PlaceholderUIView, context: Context) {
        print("update ui view \(context)")
    }
}

struct SimplePlan: View {
    @State var sessionRunning = false

    var body: some View {
        VStack {
            Text("Snornge")
            PlaceholderContainerView()
            HStack {
                Button(sessionRunning ? "End Session" : "Start Session") {
                    sessionRunning.toggle()
                }
            }
        }
    }
}

#Preview {
    SimplePlan()
}
