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
    let iv3: Inceptionv3
    
    init() {
        let configuration = MLModelConfiguration()
        iv3 = try! Inceptionv3(configuration: configuration)
    }
    
    func checkBöb() -> String {
//        let böburl = Bundle.main.url(forResource: "bob-with-lego-car", withExtension: "jpg")!
        let böburl = Bundle.main.url(forResource: "sleesstak", withExtension: "jpg")!
        let input = try! Inceptionv3Input(imageAt: böburl)
        let prediction = try! iv3.prediction(input: input)
        return prediction.classLabel
    }
    
    func checkBob(_ imageName: String) -> String {
        let rawModel: MLModel = iv3.model
        
        class FeatureProvider: MLFeatureProvider {
            let imageName: String
       
            init(imageName: String) {
                self.imageName = imageName
            }
            
            var featureNames: Set<String> {
                get {
                    ["image"]
                }
            }
            
            func featureValue(for featureName: String) -> MLFeatureValue? {
                switch featureName {
                case "image":
                    let böburl = Bundle.main.url(forResource: imageName, 
                                                 withExtension: "jpg")!
                    
                    let imageFeatureValue = try! MLFeatureValue(
                        imageAt: böburl,
                        pixelsWide: 299,
                        pixelsHigh: 299,
                        pixelFormatType: kCVPixelFormatType_32ARGB,
                        options: nil
                    )
                    return imageFeatureValue
                default:
                    print("omgwtfbbq?")
                    return nil
                }
            }

        }
        
        let provider = FeatureProvider(imageName: imageName)
        let result = try! rawModel.prediction(from: provider)
        let featureValue = result.featureValue(for: "classLabel")
        let stringValue = featureValue?.stringValue
        return stringValue!
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
            Button("Splunge with Help") {
                print(Helperer().checkBöb())
            }
             Button("Splunge without Help") {
                print(Helperer().checkBob("sleesstak"))
            }
       }
        .padding()
    }
}

#Preview {
    ContentView()
}
