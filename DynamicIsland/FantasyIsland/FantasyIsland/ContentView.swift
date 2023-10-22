//
//  ContentView.swift
//  FantasyIsland
//
//  Created by markd on 10/22/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "airplane")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bozz.  the plane! the plane!!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
