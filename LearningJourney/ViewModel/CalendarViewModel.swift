//
//  CalendarViewModel.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Prepares everything the calendar screen needs:
//  the list of months, the days of each month (with empty spaces before day 1),
//  the weekday names, and the status of each day.
//  All date math uses Apple's Calendar API, so we do not calculate dates by hand.
//

import Foundation
import Observation

// @Observable: the calendar screen updates when the data changes.
// class: it shares the SAME ActivityViewModel object with the other screens.
@Observable
final class CalendarViewModel {

    // The shared object that has all the logged days.
    private let activityViewModel: ActivityViewModel

    // Apple's calendar for this device (it knows month lengths, weekdays, and so on).
    private let calendar = Calendar.current

    init(activityViewModel: ActivityViewModel) {
        self.activityViewModel = activityViewModel
    }

    // The first day of each month to show, from January of this year
    // (or the goal start, if it is earlier) until the current month.
    var months: [Date] {
        guard let year = calendar.dateInterval(of: .year, for: .now) else {
            return []
        }

        // min: the earlier of the two dates. Date can be compared, like Comparable in Java.
        var month = min(year.start, monthStart(of: activityViewModel.goal.start))
        let lastMonth = currentMonth
        var result: [Date] = []

        // Add one month at a time until we reach the current month.
        while month <= lastMonth {
            result.append(month)
            guard let next = calendar.date(byAdding: .month, value: 1, to: month) else { break }
            month = next
        }
        return result
    }

    // The month we scroll to when the screen opens.
    var currentMonth: Date {
        monthStart(of: .now)
    }

    // The days of one month, with empty spaces before day 1,
    // so day 1 sits under the right weekday.
    // [Date?]: a list of Optionals. nil = an empty space in the grid.
    func days(in month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else {
            return []
        }

        // How many empty spaces before day 1?
        // It depends on which weekday the month starts on.
        let firstWeekday = calendar.component(.weekday, from: month)
        let blanksCount = (firstWeekday - calendar.firstWeekday + 7) % 7
        let blanks: [Date?] = Array(repeating: nil, count: blanksCount)

        // Make a date for every day of the month (1, 2, 3, ...).
        let dates = range.map { day in
            calendar.date(byAdding: .day, value: day - 1, to: month)
        }

        // Empty spaces first, then the days.
        return blanks + dates
    }

    // SUN MON TUE ... in the order the device uses.
    var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols.map { $0.uppercased() }
        let shift = calendar.firstWeekday - 1
        // Move the list so it starts from the device's first weekday.
        return Array(symbols[shift...] + symbols[..<shift])
    }

    // The status of any day (learned, freezed, or nil if not logged).
    func status(for date: Date) -> DayStatus? {
        activityViewModel.status(for: date)
    }

    // The first day of the month that contains this date.
    // ?. : if dateInterval is nil, stop and give nil. ?? : then use the date itself.
    private func monthStart(of date: Date) -> Date {
        calendar.dateInterval(of: .month, for: date)?.start ?? date
    }
}
