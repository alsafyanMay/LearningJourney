//
//  GoalState.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Describes where the user is in their goal right now.
//  The Activity screen uses it to decide what to show:
//  the log button, the "Well done" message, or the "Not met" message.
//

import Foundation

// An enum with three fixed choices.
// The goal is always in exactly one of these states, never two at once.
// ActivityViewModel calculates the state, and ActivityView uses a switch on it.
enum GoalState {

    // The goal is still running: show the log circle and the freeze button.
    case inProgress

    // The user logged enough days to finish the goal: show "Well done!".
    case completed

    // More than 32 hours passed without logging: the streak is broken.
    // Show "You didn't reach your goal this time."
    case notMet
}
