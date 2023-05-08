import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func thing1() {
        Task {
            let url = URL(string: "https://swapi.dev/api/vehicles")!
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                textView.text += "unexpected status code \(response)"
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let string = String(data: data, encoding: .utf8)!
            print(string)

            do {
                let page = try decoder.decode(WebVehiclePage.self, from: data)
                let vehicles = try page.results?.map(Vehicle.init(webVehicle:))
                vehicles?.forEach {
                    textView.text += "\($0)\n\n"
                }
            } catch {
                textView.text += "oops, error. \(error)"
            }
        }
    }

    var cancellable: AnyCancellable?

    @IBAction func thing2() {
        let url = URL(string: "https://swapi.dev/api/vehicles")!

        let urlSession = URLSession.shared
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        cancellable = urlSession
          .dataTaskPublisher(for: url)
          .tryMap() { element -> Data in
              guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                  throw "Spork"
              }
              return element.data
          }
          .decode(type: WebVehiclePage.self, decoder: decoder)
        .tryMap() { page -> [Vehicle] in
            guard let results = page.results else { throw "no results" }
            return try results.compactMap(Vehicle.init(webVehicle:))
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print("received completion \($0)") },
              receiveValue: { [self] vehicles in
                  vehicles.forEach {
                    textView.text += "\($0)\n\n"
                  }
              })
    }

}

extension String: Error {}

struct WebVehicle: Codable {
    let name: String?
    let manufacturer: String?
    let costInCredits: String?
}

struct WebVehiclePage: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [WebVehicle]?
}

struct Vehicle {
    let name: String
    let manufacturer: String
    let costInCredits: String

    enum VehicleError: Error {
        case missingData
    }

    init(webVehicle: WebVehicle) throws {
        guard let name = webVehicle.name,
              let manufacturer = webVehicle.manufacturer,
              let costInCredits = webVehicle.costInCredits else {
            throw VehicleError.missingData
        }
        self.name = name
        self.manufacturer = manufacturer
        self.costInCredits = costInCredits
    }
}
