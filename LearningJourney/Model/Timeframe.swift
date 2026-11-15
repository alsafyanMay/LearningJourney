//
//  Timeframe.swift
//  LearningJourney
//
//  Created by may.mohammed on 04/06/1448 AH.
//
//  What this file does:
//  Describes how long a learning goal lasts: a week, a month, or a year.
//  Each choice also knows how many days it has
//  and how many freezes the user is allowed to use.
//

import Foundation

// An enum with three fixed choices.
// String: each case has a text value (rawValue) that we show on the buttons,
//         for example Timeframe.week.rawValue is "Week".
// CaseIterable: gives us Timeframe.allCases (all choices in a list),
//               so the Week / Month / Year buttons are created from it automatically.
// Codable: lets us save it to the device and load it back.
enum Timeframe: String, CaseIterable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    // How many freezes the user can use in this timeframe.
    // A computed property: the value is calculated each time, not stored.
    // The switch must cover every case, or the code will not compile.
    var maxFreezes: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }

    // How many days the user must log to complete the goal.
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
}
