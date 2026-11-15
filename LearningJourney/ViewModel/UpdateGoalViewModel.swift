//
//  UpdateGoalViewModel.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  Holds a draft copy of the goal while the user edits it on the Learning Goal screen.
//  The real goal does not change until the user taps "Update" in the alert.
//  If they tap "Dismiss", the draft is thrown away and nothing changes.
//

import Foundation
import Observation

// @Observable: the screen updates when the draft changes.
// class: the screen needs one object that stays the same and can be changed.
@Observable
final class UpdateGoalViewModel {

    // The draft: a copy the user edits without touching the real goal.
    var desire: String
    var cycle: Timeframe

    // The shared object that has the real goal.
    // ActivityViewModel is a class, so this points to the SAME object
    // the Activity screen uses. Any change here shows there right away.
    private let activityViewModel: ActivityViewModel

    // Fills the draft with the current goal, so the form opens already filled.
    // We write this init ourselves because a class does not get one automatically
    // when its properties have no default values.
    init(activityViewModel: ActivityViewModel) {
        self.activityViewModel = activityViewModel
        desire = activityViewModel.goal.desire
        cycle = activityViewModel.goal.cycle
    }

    // Can the user tap the checkmark?
    // Only if the text is not empty or just spaces.
    var canSave: Bool {
        !trimmedDesire.isEmpty
    }

    // The text without spaces at the start and the end.
    private var trimmedDesire: String {
        desire.trimmingCharacters(in: .whitespaces)
    }

    // Called when the user taps "Update" in the alert.
    // Applies the draft to the real goal. The streak starts over from zero.
    func confirmUpdate() {
        activityViewModel.updateGoal(desire: trimmedDesire, cycle: cycle)
    }
}
