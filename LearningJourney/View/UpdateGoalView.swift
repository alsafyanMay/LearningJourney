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

    // Did the user tap "Update" in the alert? (Dismiss leaves it false.)
    @State private var didConfirm = false

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
        .padding(.horizontal)
        .padding(.top, 36)   // the form starts 36 below the navigation bar in the design
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)   // small title in the middle of the bar

        // The checkmark button at the top right of the navigation bar.
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    // Show the alert first, do not update yet. No slide animation: the alert just appears.
                    didConfirm = false
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isShowingAlert = true
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.glassProminent)   // Liquid Glass button in the toolbar
                .tint(Color(red: 1.0, green: 0.573, blue: 0.188))   // #FF9230 from the design
                .disabled(!viewModel.canSave)   // disabled if the text is empty
            }
        }

        // The confirmation alert. We use a full screen cover so the dark overlay
        // also covers the navigation bar, like in the design.
        // onDismiss runs after the cover is gone: only then do we apply the update and go back.
        .fullScreenCover(isPresented: $isShowingAlert, onDismiss: {
            if didConfirm {
                viewModel.confirmUpdate()
                dismiss()
            }
        }) {
            alertOverlay
                .presentationBackground(.clear)   // see the screen behind through the overlay
        }
    }

    // MARK: - Alert

    // The dark overlay with the alert card, from the Sketch design.
    private var alertOverlay: some View {
        ZStack {
            // #121212 at 56% in Dark, from the design.
            Color.appOverlay
                .ignoresSafeArea()

            // The card starts 372 points from the top of the screen in the design.
            VStack(spacing: 0) {
                CustomAlert(
                    title: "Update goal",
                    message: "If you update now, your streak will start over.",
                    cancelTitle: "Dismiss",
                    confirmTitle: "Update",
                    onCancel: { closeAlert(confirmed: false) },
                    onConfirm: { closeAlert(confirmed: true) }
                )
                Spacer(minLength: 0)
            }
            .padding(.top, 372)
            .ignoresSafeArea()
        }
    }

    // Closes the cover without the slide animation. The action itself runs in onDismiss above.
    private func closeAlert(confirmed: Bool) {
        didConfirm = confirmed
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            isShowingAlert = false
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
