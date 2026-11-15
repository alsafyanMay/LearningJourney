//
//  CalendarView.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Shows all the months, from the start of the year until now.
//  Learned days are orange, freezed days are blue, and today is solid orange.
//  The calendar is view only: the user can scroll but cannot tap the days.
//  It opens on the current month.
//

import SwiftUI

struct CalendarView: View {

    // The screen owns its ViewModel. @State keeps it alive while the screen is open.
    @State private var viewModel: CalendarViewModel

    // 7 columns with equal width, one for each day of the week.
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    // We need a custom init because the ViewModel needs a parameter.
    // _viewModel (with underscore) is the @State wrapper itself, not the value inside it.
    init(activityViewModel: ActivityViewModel) {
        _viewModel = State(initialValue: CalendarViewModel(activityViewModel: activityViewModel))
    }

    var body: some View {
        // ScrollViewReader: lets us scroll to a month by its id.
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.months, id: \.self) { month in
                        monthSection(month)
                            .id(month)   // give each month an id so we can scroll to it

                        Divider()        // a line between months, like the design
                    }
                }
                .padding()
            }
            .onAppear {
                // When the screen opens, scroll to the current month.
                proxy.scrollTo(viewModel.currentMonth, anchor: .top)
            }
        }
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
    }

    // One month: the title, the weekday names, and the grid of days.
    // A function that returns a view: like a computed property, but it takes a parameter.
    private func monthSection(_ month: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            // For example "January 2026".
            Text(month.formatted(.dateTime.month(.wide).year()))
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 12) {

                // The first row: SUN MON TUE ...
                ForEach(viewModel.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }

                // The days. enumerated() gives each item a number (offset),
                // which we use as its id, because the empty spaces (nil) all look the same.
                ForEach(Array(viewModel.days(in: month).enumerated()), id: \.offset) { item in
                    // if let: a real day draws a circle, nil draws an empty space.
                    if let date = item.element {
                        DayCircle(date: date, status: viewModel.status(for: date))
                    } else {
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
    }
}

// Fake data: a goal that started 40 days ago, with 35 days logged.
#Preview {
    NavigationStack {
        CalendarView(activityViewModel: .preview(startDaysAgo: 40, loggedDays: 35))
    }
    .preferredColorScheme(.dark)
}
