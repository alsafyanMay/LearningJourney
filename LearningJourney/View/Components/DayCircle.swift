//
//  DayCircle.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Draws one day number inside a circle.
//  The color shows what happened on that day:
//  orange = learned, blue = freezed, solid orange = today (not logged yet).
//  Used by WeekStripView on the Activity screen.
//

import SwiftUI

// A small reusable piece of UI (a Component).
// It does not know where the data comes from. It just draws what it is given.
struct DayCircle: View {

    // The day to show.
    let date: Date

    // What happened on that day.
    // Optional: nil means the day was not logged.
    let status: DayStatus?

    var body: some View {
        // The day number only, for example "17".
        Text(date.formatted(.dateTime.day()))
            .fontWeight(.medium)
            .foregroundStyle(colors.text)
            .frame(width: 36, height: 36)
            .background(colors.background, in: .circle)
    }

    // The text color and the circle color, returned together.
    // A tuple: a quick way to return two values without making a new type.
    // Colors live here in the View, not in the Model, because the Model does not know SwiftUI.
    private var colors: (text: Color, background: Color) {
        switch status {

        // Learned day: orange text on a light orange circle.
        case .learned:
            return (.orange, .orange.opacity(0.25))

        // Freezed day: blue text on a light blue circle.
        case .freezed:
            return (.cyan, .cyan.opacity(0.25))

        // Not logged (nil): highlight today in solid orange, leave other days plain.
        case nil:
            if Calendar.current.isDateInToday(date) {
                return (.white, .orange)
            }
            return (.white, .clear)
        }
    }
}
