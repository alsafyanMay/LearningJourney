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
    let viewModel: ActivityViewModel

    // We call this to tell ContentView: "the user wants a new goal".
    let onSetNewGoal: () -> Void

    // Tells us if the app is open on screen or in the background.
    @Environment(\.scenePhase) private var scenePhase

    // Colors taken from the Sketch file: orange #FF9230 and blue #3CD3FE.
    private let softOrange = Color(red: 1.0, green: 0.573, blue: 0.188)
    private let skyBlue = Color(red: 0.235, green: 0.827, blue: 0.996)
    private let mutedFill = Color.appMutedFill

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
                .padding(.bottom, 3)   // 15 in the design between the date and the week letters

            // The week strip. For each day, we ask the ViewModel for its status.
            // Negative padding: the design's strip is wider than the screen margins.
            WeekStripView(days: viewModel.currentWeek) { date in
                viewModel.status(for: date)
            }
            .padding(.horizontal, -8.5)

            // Two cards: learned days and freezed days.
            HStack(spacing: 12) {
                StatCard(icon: "flame.fill", color: softOrange,
                         count: viewModel.learnedCount, title: "Learned")
                StatCard(icon: "snowflake", color: skyBlue,
                         count: viewModel.freezedCount, title: "Freezed")
            }
            .padding(.horizontal, -2)   // the design's cards are slightly wider than the margins

            Spacer()

            mainContent
        }
        .padding(.horizontal)
        // This screen has its own header, so we hide the system navigation bar.
        .toolbar(.hidden, for: .navigationBar)
        // At midnight, update the time so the buttons work again for the new day.
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main)) { _ in
            viewModel.refresh()
        }
        // When the user comes back to the app, update the time.
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.refresh()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Activity")
                    .font(.largeTitle.bold())
                // Today's date, for example "Thursday, 24 October".
                Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.body)                          // SF Pro 17 regular
                    .foregroundStyle(.gray)
            }

            Spacer()

            // NavigationLink: opens a new screen on top, with a back button.
            NavigationLink {
                CalendarView(activityViewModel: viewModel)
            } label: {
                headerIcon("calendar")
            }
            .buttonStyle(.plain)

            NavigationLink {
                UpdateGoalView(activityViewModel: viewModel)
            } label: {
                headerIcon("pencil.and.outline")
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }

    // One round glass button in the header.
    // A function that returns a view, so both buttons look the same.
    private func headerIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.title3)
            .foregroundStyle(.primary)
            .frame(width: 44, height: 44)
            .glassEffect(.regular.interactive(), in: .circle)   // Liquid Glass
            .overlay(Circle().strokeBorder(.primary.opacity(0.15), lineWidth: 1))
    }

    // MARK: - Main Content

    // Shows a different part of the screen for each goal state.
    // @ViewBuilder: lets each case of the switch return a different view.
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.goalState {

        case .inProgress:
            logButton
                .frame(maxWidth: .infinity)
            Spacer()
            freezeSection

        case .completed:
            GoalEndView(
                icon: "hands.clap.fill",
                title: "Well done!",
                message: "Goal completed! Start learning again or set a new learning goal.",
                onNewGoal: onSetNewGoal,
                onSameGoal: viewModel.restartSameGoal
            )
            Spacer()

        case .notMet:
            GoalEndView(
                icon: "xmark.circle",
                title: "You didn't reach your goal this time.",
                message: "Want to set another goal?",
                onNewGoal: onSetNewGoal,
                onSameGoal: nil
            )
            Spacer()
        }
    }

    // MARK: - Log Circle

    // True when today was logged as learned.
    private var isLearnedToday: Bool {
        viewModel.todayStatus == .learned
    }

    // The big circle button. Orange before logging, dark gray after.
    private var logButton: some View {
        Button {
            viewModel.logAsLearned()
        } label: {
            Text(isLearnedToday ? "Logged as Learned" : "Log as Learned")
                .font(.headline.weight(.bold))              // SF Pro 17 bold
                .foregroundStyle(isLearnedToday ? .gray : .white)
                .frame(width: 272, height: 272)
                // Liquid Glass circle. .interactive(): the glass reacts when touched.
                // Gray state: a real dark gray fill under the glass. A gray tint alone looks black on a black screen.
                .background(isLearnedToday ? mutedFill : .clear, in: .circle)
                .glassEffect(isLearnedToday ? .regular.interactive() : .regular.tint(softOrange).interactive(), in: .circle)
                .overlay(Circle().strokeBorder(rimGradient, lineWidth: 1))
        }
        .buttonStyle(.plain)
        // Not tappable after today is logged.
        // We use allowsHitTesting instead of .disabled, so the colors stay like the design.
        .allowsHitTesting(viewModel.canLog)
    }

    // A thin shiny edge, like light on the edge of real glass.
    private var rimGradient: LinearGradient {
        LinearGradient(
            colors: [.white.opacity(0.45), .white.opacity(0.05), .white.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Freeze

    // The freeze button is gray when today was freezed, or when no freezes are left.
    private var isFreezeGray: Bool {
        viewModel.todayStatus == .freezed || viewModel.freezedCount >= viewModel.maxFreezes
    }

    private var freezeSection: some View {
        VStack(spacing: 16) {
            Button {
                viewModel.freezeToday()
            } label: {
                Text(viewModel.todayStatus == .freezed ? "Freezed for a day" : "Freeze for a day")
                    .font(.body.weight(.medium))             // SF Pro 17 medium
                    .foregroundStyle(isFreezeGray ? .gray : .white)
                    .frame(width: 272, height: 46)       // size from the design (was 274 × 52)
                    .background(isFreezeGray ? mutedFill : .clear, in: .capsule)
                    .glassEffect(isFreezeGray ? .regular.interactive() : .regular.tint(skyBlue).interactive(), in: .capsule)
                    .overlay(Capsule().strokeBorder(.white.opacity(0.3), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .allowsHitTesting(viewModel.canFreeze)   // not tappable if today is logged or no freezes left

            Text("\(viewModel.freezedCount) out of \(viewModel.maxFreezes) Freezes used")
                .font(.system(size: 14))                    // SF Pro 14 regular
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 45)   // bottom gap from the design
    }
}

// MARK: - Previews

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
