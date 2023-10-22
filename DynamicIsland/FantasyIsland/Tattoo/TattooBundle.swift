//
//  TattooBundle.swift
//  Tattoo
//
//  Created by markd on 10/22/23.
//

import WidgetKit
import SwiftUI

@main
struct TattooBundle: WidgetBundle {
    var body: some Widget {
        Tattoo()
        TattooLiveActivity()
    }
}
