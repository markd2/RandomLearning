//
//  ContentView.swift
//  Whazzat
//
//  Created by Mark Dalrymple on 5/6/24.
//

import SwiftUI
import UIKit
import CoreML

class Helperer {
    let model: Inceptionv3
    
    init() {
        let configuration = MLModelConfiguration()
        model = try! Inceptionv3(configuration: configuration)
    }
    
    func checkBöb() -> String {
//        let böburl = Bundle.main.url(forResource: "bob-with-lego-car", withExtension: "jpg")!
        let böburl = Bundle.main.url(forResource: "sleesstak", withExtension: "jpg")!
        let input = try! Inceptionv3Input(imageAt: böburl)
        let prediction = try! model.prediction(input: input)
        return prediction.classLabel
    }
}

struct ContentView: View {

    func splunge() {
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Splunge") {
                print(Helperer().checkBöb())
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
