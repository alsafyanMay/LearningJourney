//
//  Goal.swift
//  LearningJourney
//
//  Created by may.mohammed on 04/06/1448 AH.
//
//  What this file does:
//  Describes one learning goal: what the user wants to learn,
//  how long the goal lasts, and when it started.
//  The start date is used to check if the goal is completed
//  and if the streak is broken.
//

import Foundation

// A struct is a simple data container (a value type).
// Each copy is independent: changing one copy does not change the others.
// Swift also gives a struct a free initializer with all its properties:
// Goal(desire: "Swift", cycle: .week)
// Codable: lets us save the goal to the device and load it back (as JSON).
struct Goal: Codable {

    // What the user wants to learn, for example "Swift".
    var desire: String

    // How long the goal lasts: week, month, or year.
    var cycle: Timeframe

    // When the goal started.
    // It has a default value (.now = this moment),
    // so we can skip it when we create a new goal.
    var start: Date = .now
}
