import Foundation
import ArgumentParser

private let version = "0.1.0"

// Sigh.  #ilyswift
@available(macOS 10.15, *)

@main
struct Pez: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
      commandName: "pez",
      abstract: "It Smells Like Pez. Don't let what's his butt forget the projector")

    @Argument(help: "This is a required argument")
    var required: String

    @Flag(help: "Reverse the ouptut")
    var reverse: Bool = false

    @Option(help: "Truncate the output to _ characters")
    var truncation: Int?

    mutating func run() async throws {
        print("\n\n")

        guard let url = URL(string: required) else {
            print("LAME. Need URL")
            return
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard var string = String(data: data, encoding: .utf8) else {
            print("LAME. Couldn't get a string from \(data)")
            return
        }

        if reverse {
            string = String(string.reversed())
        }

        if let truncation {
            string = String(string.prefix(truncation))
        }

        print(string)
    }

    mutating func run() throws {
        print("yay2 pez: \(required)")
    }
}

