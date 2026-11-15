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
// It gets the days and a way to ask for each day's status.
struct WeekStripView: View {

    // The 7 days of the current week.
    let days: [Date]

    // A closure that takes a day and returns its status.
    // It returns an Optional: nil means the day was not logged.
    // ActivityView gives us this closure, and inside it asks the ViewModel.
    let status: (Date) -> DayStatus?

    var body: some View {
        HStack {
            // One column for each day.
            // id: \.self tells SwiftUI each date is unique.
            ForEach(days, id: \.self) { date in
                VStack(spacing: 8) {

                    // The first letter of the day name, for example "S" for Sunday.
                    Text(date.formatted(.dateTime.weekday(.narrow)))
                        .font(.caption)
                        .foregroundStyle(.gray)

                    // The day number in a colored circle (another Component).
                    DayCircle(date: date, status: status(date))
                }
                .frame(maxWidth: .infinity)   // all 7 columns take equal width
            }
        }
    }
}
