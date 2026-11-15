//
//  ActivityView.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The main screen of the app. It shows today's date, the current week,
//  how many days were learned and freezed, and the buttons to log or freeze today.
//  When the goal ends, it shows "Well done!" or "Not met" instead of the buttons.
//  This screen only draws. All the rules live in ActivityViewModel.
//

import SwiftUI
import Combine   // needed for .receive(on:)

struct ActivityView: View {

    // The shared ViewModel, created by ContentView.
    // No @State here: this screen does not own it, it only uses it.
    // @Observable is enough to update the screen when data changes.
    let viewModel: ActivityViewModel

    // A closure (a block of code we call later).
    // We call it to tell ContentView: "the user wants a new goal, go back to Onboarding".
    let onSetNewGoal: () -> Void

    // Tells us if the app is open on screen or in the background.
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header

            // The week strip. For each day, we ask the ViewModel for its status.
            WeekStripView(days: viewModel.currentWeek) { date in
                viewModel.status(for: date)
            }

            // Two cards: learned days and freezed days.
            HStack(spacing: 12) {
                StatCard(icon: "flame.fill", color: .orange,
                         count: viewModel.learnedCount, title: "Learned")
                StatCard(icon: "snowflake", color: .cyan,
                         count: viewModel.freezedCount, title: "Freezed")
            }

            Spacer()

            // The log and freeze buttons, or the end message.
            mainContent
        }
        .padding(.horizontal)
        // This screen has its own header, so we hide the system navigation bar.
        .toolbar(.hidden, for: .navigationBar)
        // At midnight, the system sends a "day changed" message.
        // We update the time so the buttons are enabled again for the new day.
        // .receive(on: RunLoop.main): handle it on the main thread, where UI updates happen.
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main)) { _ in
            viewModel.refresh()
        }
        // When the user comes back to the app, update the time.
        // A day, or 32 hours, may have passed while the app was closed.
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.refresh()
            }
        }
    }

    // MARK: - Header

    // The title, today's date, and the calendar and edit buttons.
    // private var ... some View: a piece of the screen with a name,
    // so the body stays short and easy to read.
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Activity")
                    .font(.largeTitle.bold())
                // Today's date, for example "Tuesday, 17 November".
                Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            // NavigationLink: opens a new screen on top, with a back button.
            NavigationLink {
                CalendarView(activityViewModel: viewModel)
            } label: {
                Image(systemName: "calendar")
            }
            .buttonStyle(.glass)          // Liquid Glass button
            .buttonBorderShape(.circle)

            NavigationLink {
                UpdateGoalView(activityViewModel: viewModel)
            } label: {
                Image(systemName: "pencil")
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
        }
        .padding(.top)
    }

    // MARK: - Main Content

    // Shows a different part of the screen for each goal state.
    // @ViewBuilder: lets each case of the switch return a different view.
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.goalState {

        // The goal is running: show the log circle and the freeze button.
        case .inProgress:
            logButton
                .frame(maxWidth: .infinity)
            Spacer()
            freezeSection

        // The goal is done: show "Well done!" with two choices.
        case .completed:
            GoalEndView(
                icon: "hands.clap.fill",
                title: "Well done!",
                message: "Goal completed! Start learning again or set a new learning goal.",
                onNewGoal: onSetNewGoal,
                onSameGoal: viewModel.restartSameGoal   // we pass the function itself, to run later
            )
            Spacer()

        // The streak broke: show the message with one choice only.
        case .notMet:
            GoalEndView(
                icon: "xmark.circle",
                title: "You didn't reach your goal this time.",
                message: "Want to set another goal?",
                onNewGoal: onSetNewGoal,
                onSameGoal: nil   // nil: hide the "same goal" button
            )
            Spacer()
        }
    }

    // MARK: - Log Circle

    // The big circle button. Tapping it logs today as learned.
    private var logButton: some View {
        Button {
            viewModel.logAsLearned()
        } label: {
            Text(logTitle)
                .font(.title2.weight(.semibold))
                .foregroundStyle(logTextColor)
                .frame(width: 274, height: 274)
                // Liquid Glass circle. .interactive(): the glass reacts when touched.
                .glassEffect(.regular.tint(logTint).interactive(), in: .circle)
        }
        .buttonStyle(.plain)              // remove the default button flash, the glass reacts instead
        .disabled(!viewModel.canLog)      // disabled after today is logged
    }

    // The text inside the circle, based on what happened today.
    // todayStatus is Optional, so the switch also handles nil (not logged yet).
    private var logTitle: String {
        switch viewModel.todayStatus {
        case nil:      return "Log as Learned"
        case .learned: return "Learned Today"
        case .freezed: return "Day Freezed"
        }
    }

    // The color of the circle.
    private var logTint: Color {
        switch viewModel.todayStatus {
        case nil:      return .orange
        case .learned: return .orange.opacity(0.2)
        case .freezed: return .cyan.opacity(0.2)
        }
    }

    // The color of the text inside the circle.
    private var logTextColor: Color {
        switch viewModel.todayStatus {
        case nil:      return .white
        case .learned: return .orange
        case .freezed: return .cyan
        }
    }

    // MARK: - Freeze

    // The freeze button and how many freezes were used.
    private var freezeSection: some View {
        VStack(spacing: 8) {
            Button {
                viewModel.freezeToday()
            } label: {
                Text("Freeze for a day")
                    .fontWeight(.medium)
                    .padding(.horizontal, 40)
            }
            .buttonStyle(.glassProminent)     // Liquid Glass button
            .tint(.cyan)
            .controlSize(.large)
            .disabled(!viewModel.canFreeze)   // disabled if today is logged or no freezes left

            Text("\(viewModel.freezedCount) out of \(viewModel.maxFreezes) Freezes used")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
}

// MARK: - Previews

// Three previews, one for each goal state, using fake data.
// NavigationStack is needed so the NavigationLink buttons can open screens.
#Preview("In Progress") {
    NavigationStack {
        ActivityView(viewModel: .preview(startDaysAgo: 2, loggedDays: 2)) { }
    }
    .preferredColorScheme(.dark)
}

#Preview("Completed") {
    NavigationStack {
        ActivityView(viewModel: .preview(startDaysAgo: 7, loggedDays: 7)) { }
    }
    .preferredColorScheme(.dark)
}

#Preview("Not Met") {
    NavigationStack {
        ActivityView(viewModel: .preview(startDaysAgo: 3, loggedDays: 1)) { }
    }
    .preferredColorScheme(.dark)
}
