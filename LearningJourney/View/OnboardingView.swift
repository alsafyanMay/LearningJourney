//
//  OnboardingView.swift
//  LearningJourney
//
//  Created by may.mohammed on 28/05/1448 AH.
//
//  What this file does:
//  The first screen the user sees.
//  They write what they want to learn, pick a timeframe,
//  and tap "Start Learning" to begin their journey.
//

import SwiftUI

struct OnboardingView: View {

    // This screen creates and owns its ViewModel.
    // @State keeps it alive while SwiftUI redraws the screen.
    @State private var viewModel = OnboardingViewModel()

    // A closure: a block of code given to us by ContentView.
    // We run it when the user taps "Start Learning", and send it the new Goal.
    // (Like Consumer<Goal> in Java.)
    let onStart: (Goal) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            header

            // The shared form. We pass bindings ($) so the form can change the ViewModel's values.
            GoalForm(desire: $viewModel.desire, cycle: $viewModel.cycle)

            Spacer()

            startSection
        }
        .padding(.horizontal)
    }

    // The flame image and the welcome text.
    // private var ... some View: a named piece of the screen, so the body stays short.
    private var header: some View {
        VStack(alignment: .leading, spacing: 80) {
            Image("streak")   // the flame image from Assets
                .padding(.top, 60)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading) {
                // **Learner** is Markdown: it makes this word bold.
                Text("Hello **Learner**")
                    .font(.largeTitle)
                Text("This app will help you learn everyday!")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }

    // The "Start Learning" button and the small note under it.
    private var startSection: some View {
        VStack {
            Button {
                // Create the Goal in the ViewModel, then send it to ContentView.
                onStart(viewModel.makeGoal())
            } label: {
                Text("Start Learning")
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(.glassProminent)     // Liquid Glass button from the system
            .tint(.orange)
            .controlSize(.large)
            .disabled(!viewModel.canStart)    // gray and not tappable until the user types something

            Text("You can edit your desire later")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// The preview gives an empty closure ({ _ in }), because it does not need to go to the next screen.
// _ means "we receive a Goal but we do not use it".
#Preview {
    OnboardingView { _ in }
        .preferredColorScheme(.dark)
}
