//
//  ActivityViewModel.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The brain of the app. It keeps the current goal and every logged day,
//  counts learned and freezed days, decides when the buttons are enabled,
//  checks the 32-hour streak rule, and saves everything on the device.
//  The Activity, Update Goal, and Calendar screens all share this same object.
//

import Foundation
import Observation

// @Observable: any screen that reads a property from here
//              updates automatically when that property changes.
// class: it is shared. Every screen points to the SAME object,
//        so a change on one screen shows on the others right away.
// final: no other class can inherit from it.
@Observable
final class ActivityViewModel {

    // The current learning goal.
    var goal: Goal

    // Every logged day and what happened on it (learned or freezed).
    // A Dictionary: the key is the day, the value is its status.
    // private(set): screens can read it, but only this class can change it.
    private(set) var logs: [Date: DayStatus]

    // The exact time of the last log.
    // Optional: nil means the user has not logged any day yet.
    private(set) var lastLoggedAt: Date?

    // "Now" saved as a property, so when we update it,
    // every calculation and every screen updates too.
    private(set) var now: Date = .now

    // The calendar of the device, used for all date calculations.
    private let calendar = Calendar.current

    // 32 hours in seconds. After this time without logging, the streak breaks.
    private let streakLimit: TimeInterval = 32 * 60 * 60

    // The service that saves and loads progress.
    private let store: ProgressStore

    // Creates the ViewModel.
    // logs, lastLoggedAt, and store have default values,
    // so ActivityViewModel(goal:) alone creates a fresh goal with no logs.
    init(
        goal: Goal,
        logs: [Date: DayStatus] = [:],
        lastLoggedAt: Date? = nil,
        store: ProgressStore = ProgressStore()
    ) {
        self.goal = goal
        self.logs = logs
        self.lastLoggedAt = lastLoggedAt
        self.store = store
    }

    // MARK: - Saving and Loading

    // Loads the saved progress when the app opens.
    // static: we call it on the type itself: ActivityViewModel.loadSaved()
    // Returns nil (Optional) if nothing is saved,
    // so ContentView knows it should show Onboarding.
    static func loadSaved(from store: ProgressStore = ProgressStore()) -> ActivityViewModel? {
        guard let saved = store.load() else {
            return nil
        }
        return ActivityViewModel(
            goal: saved.goal,
            logs: saved.logs,
            lastLoggedAt: saved.lastLoggedAt,
            store: store
        )
    }

    // Starts a new journey from Onboarding and saves it right away.
    static func startNew(goal: Goal, store: ProgressStore = ProgressStore()) -> ActivityViewModel {
        let viewModel = ActivityViewModel(goal: goal, store: store)
        viewModel.save()
        return viewModel
    }

    // Called when the user chooses a new goal from the end screen.
    // Deletes the saved progress.
    func endJourney() {
        store.clear()
    }

    // Saves the goal, the logs, and the last log time together.
    private func save() {
        store.save(SavedProgress(goal: goal, logs: logs, lastLoggedAt: lastLoggedAt))
    }

    // MARK: - Time

    // Updates "now". Called at midnight and when the user comes back to the app.
    func refresh() {
        now = .now
    }

    // The start of today (12:00 AM).
    // When midnight comes, this becomes a new day, so the buttons are enabled again.
    private var today: Date {
        calendar.startOfDay(for: now)
    }

    // MARK: - Today

    // What happened today.
    // Optional: nil means today is not logged yet.
    var todayStatus: DayStatus? {
        logs[today]
    }

    // MARK: - Counts

    // How many days were logged as learned.
    // filter keeps only the matching items. $0 means "the current item".
    var learnedCount: Int {
        logs.values.filter { $0 == .learned }.count
    }

    // How many days were freezed.
    var freezedCount: Int {
        logs.values.filter { $0 == .freezed }.count
    }

    // How many freezes are allowed for this goal (2, 8, or 96).
    var maxFreezes: Int {
        goal.cycle.maxFreezes
    }

    // MARK: - Button Rules

    // The log button works only if today is not logged yet.
    var canLog: Bool {
        todayStatus == nil
    }

    // The freeze button works only if today is not logged
    // and the user still has freezes left.
    var canFreeze: Bool {
        todayStatus == nil && freezedCount < maxFreezes
    }

    // MARK: - Streak

    // True if more than 32 hours passed since the last log.
    // If the user never logged, we count from the goal start date.
    // ?? means "if the left side is nil, use the right side".
    var isStreakBroken: Bool {
        let reference = lastLoggedAt ?? goal.start
        return now.timeIntervalSince(reference) > streakLimit
    }

    // Decides which state the goal is in. ActivityView shows a different screen for each.
    // First: enough days logged? Completed.
    // Then: streak broken? Not met.
    // Otherwise: still in progress.
    var goalState: GoalState {
        if learnedCount + freezedCount >= goal.cycle.days {
            return .completed
        }
        if isStreakBroken {
            return .notMet
        }
        return .inProgress
    }

    // MARK: - Actions

    // Logs today as learned.
    // guard: if the user cannot log, stop here and do nothing.
    func logAsLearned() {
        guard canLog else { return }
        record(.learned)
    }

    // Uses a freeze for today.
    // A freeze keeps the streak alive, because it updates the last log time too.
    func freezeToday() {
        guard canFreeze else { return }
        record(.freezed)
    }

    // Shared steps for logging and freezing:
    // update the time, save today's status, remember the time, and save to the device.
    private func record(_ status: DayStatus) {
        refresh()
        logs[today] = status
        lastLoggedAt = now
        save()
    }

    // Changes the goal. The streak starts over from zero.
    func updateGoal(desire: String, cycle: Timeframe) {
        goal = Goal(desire: desire, cycle: cycle)
        logs = [:]
        lastLoggedAt = nil
        refresh()
        save()
    }

    // Starts the same goal again from today.
    func restartSameGoal() {
        updateGoal(desire: goal.desire, cycle: goal.cycle)
    }

    // Returns the status of any day (used by the week strip and the calendar).
    // Optional: nil means that day was not logged.
    func status(for date: Date) -> DayStatus? {
        logs[calendar.startOfDay(for: date)]
    }

    // MARK: - Week

    // The 7 days of the current week, used by the week strip.
    var currentWeek: [Date] {
        // guard let: if the week cannot be found, return an empty list.
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else {
            return []
        }
        // Make 7 dates starting from the first day of the week.
        // compactMap skips any date that could not be created (nil).
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: week.start)
        }
    }
}

// MARK: - Preview Helper

// Fake data for testing the screens in the Xcode Preview.
// #if DEBUG: this code is not included in the App Store version.
// extension: adds extra code to a type without changing its main definition.
#if DEBUG
extension ActivityViewModel {

    // Creates a goal that started some days ago, with some days already logged.
    // This lets us preview the In Progress, Completed, and Not Met states.
    static func preview(startDaysAgo: Int, loggedDays: Int) -> ActivityViewModel {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let start = calendar.date(byAdding: .day, value: -startDaysAgo, to: today) ?? today

        let viewModel = ActivityViewModel(goal: Goal(desire: "Swift", cycle: .week, start: start))

        // Log the first days of the goal as learned.
        for offset in 0..<loggedDays {
            if let day = calendar.date(byAdding: .day, value: offset, to: start) {
                viewModel.logs[day] = .learned
            }
        }

        // Set the last log time to match the last logged day.
        if loggedDays > 0 {
            let daysSinceLastLog = startDaysAgo - loggedDays + 1
            viewModel.lastLoggedAt = calendar.date(byAdding: .day, value: -daysSinceLastLog, to: .now)
        }

        return viewModel
    }
}
#endif
