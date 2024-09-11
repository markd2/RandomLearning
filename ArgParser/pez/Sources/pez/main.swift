import Foundation
import ArgumentParser

enum MarkDisms: String {
    case forgotProjector
    case leftPhoneInCar
    case ilyxc
}

@main
struct Pez: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
      commandName: "pez",
      abstract: "It Smells Like Pez. Don't let what's his butt forget the projector",
      subcommands: [DownloadPezCommand.self])

    @Option(parsing: .next,
            help: "Fnord greeble ekky hoover ni bork",
            transform: MarkDisms.init)
    var bork: MarkDisms? = .ilyxc

    @Option(help: "More types!")
    var scale: Double = 1.0

    @OptionGroup var globalOptions: GlobalOptions

    mutating func run() async throws {
        print("\n\n")
        print("base command - \(100 * scale)")

        if let bork {
            print("\(bork)")
        }
        if globalOptions.verbose {
            print("  all your base are belong to pez")
        }
    }
}

struct GlobalOptions: ParsableArguments {
    @Flag(help: "Be chatty")
    var verbose = false

    @Option(help: "splunge")
    var splunge = ""
}


struct DownloadPezCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
      commandName: "download-pez",
      abstract: "It Smells Like Pez. Don't let what's his butt forget the projector")

    @Argument(help: "This is a required argument")
    var required: String

    @Flag(name: .shortAndLong,
          help: "Reverse the ouptut")
    var reverse: Bool = false

    @Option(name: [.customShort("x"), .customLong("enshorten")],
            help: "Truncate the output to _ characters")
    var truncation: Int?

    @OptionGroup var gloptions: GlobalOptions

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
        
        if gloptions.verbose {
            print("  all your pez are belong to base")
        }
    }
}
