//
//  SplungeDataApp.swift
//  SplungeData
//
//  Created by Mark Dalrymple on 7/27/23.
//

import SwiftUI

@main
struct SplungeDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
