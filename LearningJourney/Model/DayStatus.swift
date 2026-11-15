//
//  DayStatus.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Describes what happened on a logged day: the user either learned or used a freeze.
//  A day that was not logged has no status at all, so we use nil (Optional) for it
//  instead of adding a third case.
//

import Foundation

// An enum is a type with a fixed list of choices.
// String: each case is saved as text ("learned" or "freezed").
// Codable: lets us save it to the device and load it back (as JSON).
enum DayStatus: String, Codable {

    // The user logged this day as learned.
    case learned

    // The user used a freeze on this day, so the streak is kept.
    case freezed
}
