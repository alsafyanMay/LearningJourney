//
//  DayCircle.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Draws one day number inside a circle.
//  Orange text = learned, blue text = freezed, solid orange = today (not logged yet).
//  Used by WeekStripView and CalendarView.
//

import SwiftUI

// A reusable Component. It just draws what it is given.
struct DayCircle: View {
    let date: Date

    // Optional: nil means the day was not logged.
    let status: DayStatus?

    var body: some View {
        Text(date.formatted(.dateTime.day()))
            .font(.title3.weight(weight))
            .foregroundStyle(colors.text)
            .frame(width: 44, height: 44)
            .background(colors.background, in: .circle)
    }

    // Today (not logged yet) is Semibold, learned days are Medium, other days Regular.
    private var weight: Font.Weight {
        if status == nil {
            return Calendar.current.isDateInToday(date) ? .semibold : .regular
        }
        return .medium
    }

    // The text color and the circle color, returned together (a tuple).
    private var colors: (text: Color, background: Color) {
        let softOrange = Color(red: 1.0, green: 0.573, blue: 0.188)   // #FF9230
        let skyBlue = Color(red: 0.235, green: 0.827, blue: 0.996)    // #3CD3FE

        switch status {
        case .learned:
            return (softOrange, softOrange.opacity(0.12))  // orange text on dark brown
        case .freezed:
            return (skyBlue, skyBlue.opacity(0.12))        // blue text on dark blue
        case nil:
            if Calendar.current.isDateInToday(date) {
                return (.white, softOrange)                // today: solid orange
            }
            return (.primary, .clear)                        // other days: plain
        }
    }
}
