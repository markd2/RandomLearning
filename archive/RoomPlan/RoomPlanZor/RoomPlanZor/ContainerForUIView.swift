//
//  ContainerForUIView.swift
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
