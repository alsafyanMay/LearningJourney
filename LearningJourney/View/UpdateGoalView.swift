//
//  UpdateGoalView.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  The "Learning Goal" screen, opened from the pencil button on the Activity screen.
//  The user edits what they want to learn and the timeframe,
//  then taps the checkmark. An alert asks them to confirm,
//  because updating the goal restarts the streak.
//

import SwiftUI

struct UpdateGoalView: View {

    // This screen creates and owns its ViewModel (the draft of the goal).
    @State private var viewModel: UpdateGoalViewModel

    // Is the alert showing? This is only about the screen (UI state),
    // so it lives here in the View, not in the ViewModel.
    @State private var isShowingAlert = false

    // @Environment: a value SwiftUI gives us.
    // dismiss closes this screen and goes back to the Activity screen.
    @Environment(\.dismiss) private var dismiss

    // We need a custom init because the ViewModel needs a parameter.
    // _viewModel (with underscore) is the @State wrapper itself, not the value inside it.
    init(activityViewModel: ActivityViewModel) {
        _viewModel = State(initialValue: UpdateGoalViewModel(activityViewModel: activityViewModel))
    }

    var body: some View {
        VStack(alignment: .leading) {
            // The same form as the Onboarding screen. This is why it is a Component.
            GoalForm(desire: $viewModel.desire, cycle: $viewModel.cycle)
            Spacer()
        }
        .padding()
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)   // small title in the middle of the bar

        // The checkmark button at the top right of the navigation bar.
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    isShowingAlert = true   // show the alert first, do not update yet
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.glassProminent)   // Liquid Glass button in the toolbar
                .tint(.orange)
                .disabled(!viewModel.canSave)   // disabled if the text is empty
            }
        }

        // The confirmation alert.
        // isPresented is a binding: when isShowingAlert becomes true the alert shows,
        // and when the alert closes SwiftUI sets it back to false.
        .alert("Update goal", isPresented: $isShowingAlert) {

            // role: .cancel gives this button the standard cancel look and position.
            // It does nothing, so the real goal stays the same.
            Button("Dismiss", role: .cancel) { }

            // Apply the draft to the real goal, then go back to the Activity screen.
            Button("Update") {
                viewModel.confirmUpdate()
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
    }
}

// NavigationStack is needed in the preview to show the title and the toolbar.
#Preview {
    NavigationStack {
        UpdateGoalView(activityViewModel: ActivityViewModel(goal: Goal(desire: "Swift", cycle: .month)))
    }
    .preferredColorScheme(.dark)
}
