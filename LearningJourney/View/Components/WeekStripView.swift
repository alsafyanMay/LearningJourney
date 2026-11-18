//
//  WeekStripView.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The row of the 7 days of the current week on the Activity screen.
//  Each day shows its letter (S M T W T F S) and its number in a colored circle.
//

import SwiftUI

// A reusable Component. It does not know about the ViewModel.
struct WeekStripView: View {
    // The 7 days of the current week.
    let days: [Date]

    // A closure that takes a day and returns its status (nil = not logged).
    let status: (Date) -> DayStatus?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { date in
                VStack(spacing: 4) {
                    // The first letter of the day name, for example "S".
                    Text(date.formatted(.dateTime.weekday(.narrow)))
                        .font(.footnote.weight(.semibold))   // SF Pro 13 semibold
                        .foregroundStyle(.primary)

                    // The day number in a colored circle.
                    DayCircle(date: date, status: status(date))
                }
                .frame(maxWidth: .infinity)   // all 7 columns take equal width
            }
        }
    }
}
