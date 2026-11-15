//
//  SavedProgress.swift
//  LearningJourney
//
//  Created by may.mohammed on 07/06/1448 AH.
//
//  What this file does:
//  A snapshot of everything we need to remember about the user's progress.
//  We save it as one piece of data, and load it back when the app opens,
//  so the streak and the logged days are not lost.
//

import Foundation

// A struct that groups all the saved data together.
// Codable: Swift turns it into JSON and back automatically,
// because everything inside it (Goal, Date, DayStatus) is also Codable.
struct SavedProgress: Codable {

    // The current learning goal (what, how long, and when it started).
    var goal: Goal

    // Every logged day and what happened on it.
    // A Dictionary: the key is the day, the value is learned or freezed.
    var logs: [Date: DayStatus]

    // The exact time of the last log (learned or freeze).
    // Optional: nil means the user has not logged any day yet.
    // We use it to check the 32-hour streak rule.
    var lastLoggedAt: Date?
}
