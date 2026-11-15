//
//  GoalEndView.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The message shown when a goal ends.
//  The same design is used for both endings ("Well done!" and "Not met").
//  Only the icon, the text, and the buttons change.
//

import SwiftUI

// A reusable Component. ActivityView decides what to show
// and passes the text and the actions in.
struct GoalEndView: View {

    // The SF Symbol name, for example "hands.clap.fill".
    let icon: String

    // The main line, for example "Well done!".
    let title: String

    // The smaller line under the title.
    let message: String

    // What happens when the user taps "Set new learning goal".
    // A closure: a block of code we keep and run later, when the button is tapped.
    let onNewGoal: () -> Void

    // What happens when the user taps "Set same learning goal and duration".
    // Optional closure: if it is nil, we do not show this button at all.
    // The brackets around () -> Void are needed,
    // otherwise Swift reads it as a closure that returns an Optional.
    let onSameGoal: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            // Main button. We pass the closure directly as the button's action.
            Button(action: onNewGoal) {
                Text("Set new learning goal")
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(.glassProminent)   // Liquid Glass button
            .tint(.orange)
            .controlSize(.large)
            .padding(.top)

            // if let: show this button only when an action was given (not nil).
            // "Completed" passes an action, "Not met" passes nil.
            if let onSameGoal {
                Button("Set same learning goal and duration", action: onSameGoal)
                    .font(.subheadline)
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
