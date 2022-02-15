#!/usr/bin/swift

import Foundation

let formatter = RelativeDateTimeFormatter()

let date1 = 0.dateFrom
let hundredSecondsFromNow = 100.dateFrom

let dates: [Int] = [-24 * 60 * 60 * 5,
                    -60 * 60,
                    -15,
                    0,
                    15,
                    60 * 60,
                    24 * 60 * 60 * 2]

print("numeric")
formatter.dateTimeStyle = .numeric
dates.forEach {
    let blah = formatter.localizedString(for: $0.dateFrom,
                                         relativeTo: date1)
    print("\($0) - \(blah)")
}

print("\nnamed")
formatter.dateTimeStyle = .named
dates.forEach {
    let blah = formatter.localizedString(for: $0.dateFrom,
                                         relativeTo: date1)
    print("\($0) - \(blah)")
}


extension Double {
    /// Date from self-seconds since reference date
    /// 0.dateFrom
    var dateFrom: Date {
        Date(timeIntervalSinceReferenceDate: TimeInterval(self))
    }
}

extension Int {
    /// Date from self-seconds since reference date
    /// 0.dateFrom
    var dateFrom: Date {
        Date(timeIntervalSinceReferenceDate: TimeInterval(self))
    }
}

