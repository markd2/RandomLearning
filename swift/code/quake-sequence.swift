import Foundation

// from WWDC session
struct QuakesTool {
    static func main() async throws {
        let endpointURL = URL(string:
                                "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!
        // skip the header line and iterate each one
        // to extract the magnitude, time, latitude and longitude
        for try await event in endpointURL.lines.dropFirst() {
            let values = event.split (separator: ",")
            let time = values [0]
            let latitude = values[1]
            let longitude = values [2]
            let magnitude = values [4]
            print( "Magnitude \(magnitude) on \(time) at \(latitude) \(longitude)")
        }
    }
}

try await QuakesTool.main()

