#!/usr/bin/swift

import Foundation

let formatter = RelativeDateTimeFormatter()

let date1 = 0.dateFrom
let hundredSecondsFromNow = 100.dateFrom

let blah = formatter.localizedString(for: hundredSecondsFromNow,
                                     relativeTo: date1)
print(blah)



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

