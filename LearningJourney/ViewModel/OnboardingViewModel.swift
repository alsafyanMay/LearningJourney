//
//  OnboardingViewModel.swift
//  LearningJourney
//
//  Created by may.mohammed on 04/06/1448 AH.
//
//  What this file does:
//  Holds what the user types and picks on the Onboarding screen,
//  checks if they are allowed to start,
//  and creates the Goal when they tap "Start Learning".
//

import Foundation
import Observation

// @Observable: any screen that reads a property from here
//              updates automatically when that property changes.
// class: the screen needs one object that stays the same and can be changed.
// final: no other class can inherit from it.
@Observable
final class OnboardingViewModel {

    // What the user types in the text field. Starts empty.
    var desire = ""

    // The timeframe the user picks. Week is selected by default.
    var cycle: Timeframe = .week

    // Can the user tap "Start Learning"?
    // Only if they typed something that is not just spaces.
    // This is logic, so it lives here and not in the View.
    var canStart: Bool {
        !trimmedDesire.isEmpty
    }

    // The text without spaces at the start and the end.
    // private: only used inside this class, the View does not need it.
    private var trimmedDesire: String {
        desire.trimmingCharacters(in: .whitespaces)
    }

    // Creates the Goal from what the user entered.
    // The start date is set to now automatically (default value in Goal).
    func makeGoal() -> Goal {
        Goal(desire: trimmedDesire, cycle: cycle)
    }
}
