//
//  TimeframePicker.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The Week / Month / Year buttons.
//  The selected one is orange glass, the others are clear glass.
//  Used inside GoalForm, on the Onboarding and Update Goal screens.
//

import SwiftUI

// A reusable Component. It does not own the selected value.
struct TimeframePicker: View {

    // @Binding: a two-way connection to a value owned by someone else.
    // When the user taps a button, the ViewModel's value changes too.
    // (Like passing a reference to a field in Java, instead of a copy of its value.)
    @Binding var selection: Timeframe

    var body: some View {
        HStack(spacing: 12) {

            // One button for each timeframe.
            // allCases comes from CaseIterable: [.week, .month, .year].
            // id: \.self tells SwiftUI each case is unique, so it can tell the buttons apart.
            ForEach(Timeframe.allCases, id: \.self) { timeframe in

                // Is this the selected button? We use it for the colors below.
                let isSelected = selection == timeframe

                Button {
                    // Tapping a button selects it. This also changes the ViewModel (Binding).
                    selection = timeframe
                } label: {
                    // rawValue is the text of the case: "Week", "Month", or "Year".
                    Text(timeframe.rawValue)
                        .fontWeight(.medium)
                        // Sizes taken from the Sketch design.
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .foregroundStyle(isSelected ? .white : .gray)
                        // Liquid Glass capsule: orange when selected, clear when not.
                        // .interactive(): the glass reacts when the user touches it.
                        .glassEffect(
                            .regular.tint(isSelected ? .orange : .clear).interactive(),
                            in: .capsule
                        )
                }
                // Remove the default button flash. The glass gives the touch feedback instead.
                .buttonStyle(.plain)
            }
        }
    }
}

// .constant(...): a fixed value, only for the preview, because there is no ViewModel here.
#Preview {
    TimeframePicker(selection: .constant(.month))
        .preferredColorScheme(.dark)
}
