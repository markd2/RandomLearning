import Foundation

// courtesy mxcl via https://stackoverflow.com/a/46354989
public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

