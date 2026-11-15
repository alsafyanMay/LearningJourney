//
//  ProgressStore.swift
//  LearningJourney
//
//  Created by may.mohammed on 07/06/1448 AH.
//
//  What this file does:
//  Saves the user's progress on the device and loads it back when the app opens.
//  The ViewModel only asks "save" or "load" and does not care how it is done.
//  If we switch to another storage later (like SwiftData), we only change this file.
//

import Foundation

// A small service that talks to UserDefaults (simple storage on the device).
// It is a struct because it has no data that changes. It only does work.
struct ProgressStore {

    // The name we save the data under, like a label on a box.
    private let key = "learningProgress"

    // UserDefaults: built-in key-value storage that stays after the app is closed.
    private let defaults = UserDefaults.standard

    // Loads the saved progress.
    // Returns nil (Optional) when there is nothing saved yet,
    // for example the first time the user opens the app.
    func load() -> SavedProgress? {
        // guard let: if there is no saved data, stop here and return nil.
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        // Turn the saved JSON back into a SavedProgress.
        // try?: if the data is broken, return nil instead of crashing the app.
        return try? JSONDecoder().decode(SavedProgress.self, from: data)
    }

    // Saves the progress.
    // We call it every time the user logs a day or updates the goal.
    func save(_ progress: SavedProgress) {
        // Turn SavedProgress into JSON data. If this fails, do nothing.
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }
        defaults.set(data, forKey: key)
    }

    // Deletes the saved progress.
    // We call it when the user chooses to set a new goal from the end screen.
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
