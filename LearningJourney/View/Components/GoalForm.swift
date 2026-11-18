//
//  GoalForm.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The form where the user writes what they want to learn
//  and picks a timeframe (Week / Month / Year).
//  The same form is used on two screens: Onboarding and Update Goal.
//

import SwiftUI

// A reusable Component. It does not own the data.
// It edits values that belong to the screen that uses it.
struct GoalForm: View {

    // @Binding: a two-way connection to a value owned by someone else.
    // When the user types here, the ViewModel's value changes too.
    // (Like passing a reference to a field in Java, instead of a copy of its value.)
    @Binding var desire: String
    @Binding var cycle: Timeframe

    var body: some View {
        // Spacing and sizes taken from the Sketch design.
        VStack(alignment: .leading, spacing: 30) {

            // "I want to learn" + the text field + a line under it.
            VStack(alignment: .leading, spacing: 0) {
                Text("I want to learn")
                    .font(.callout)   // SF Pro 16
                    .padding(.bottom, 5)
                // "Swift" is the placeholder (gray hint text), not a real value.
                // $desire: we pass the binding, because the text field needs to write into it.
                TextField("Swift", text: $desire)
                    .autocorrectionDisabled()   // no auto-correct or suggestions while typing
                    .frame(height: 48)          // the field is 48 tall in the design
                Divider()
            }

            // "I want to learn it in a" + the Week / Month / Year buttons.
            VStack(alignment: .leading, spacing: 13) {
                Text("I want to learn it in a")
                    .font(.callout)   // SF Pro 16
                // We pass the same binding down again, so the picker can change it.
                TimeframePicker(selection: $cycle)
            }
        }
    }
}
