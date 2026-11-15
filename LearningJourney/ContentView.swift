//
//  ContentView.swift
//  LearningJourney
//
//  Created by may.mohammed on 28/05/1448 AH.
//
//  What this file does:
//  The root screen of the app. It decides what the user sees:
//  - First, the animated splash screen.
//  - Then, the Activity screen if there is a saved journey,
//    or the Onboarding screen if the user has no goal yet.
//

import SwiftUI

struct ContentView: View {

    // The shared ViewModel for the whole journey.
    // Optional: nil means there is no goal yet, so we show Onboarding.
    // When the app opens, we try to load the saved progress from the device.
    @State private var activityViewModel: ActivityViewModel? = ActivityViewModel.loadSaved()

    // Shows the splash screen once, when the app opens.
    @State private var isShowingSplash = true

    var body: some View {
        // ZStack: the splash screen sits on top of the real screen.
        ZStack {
            mainContent

            if isShowingSplash {
                // When the splash animation ends, hide it with a smooth fade.
                SplashView {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)   // fade out when it is removed
                .zIndex(1)              // stay on top while fading out
            }
        }
    }

    // Shows Activity or Onboarding.
    // There is no NavigationLink between them: Onboarding happens once with no way back,
    // so we just switch the screen when activityViewModel changes from nil to a value.
    // @ViewBuilder: lets the if / else return two different views.
    @ViewBuilder
    private var mainContent: some View {

        // if let: if there is a ViewModel (not nil), unwrap it and show Activity.
        if let activityViewModel {
            // NavigationStack: needed so Activity can open Calendar and Update Goal with a back button.
            NavigationStack {
                ActivityView(viewModel: activityViewModel) {
                    // The user chose a new goal from the end screen.
                    // 1. Delete the saved progress (this is the unwrapped copy from if let).
                    activityViewModel.endJourney()
                    // 2. Set the real property back to nil, so Onboarding shows again.
                    //    self. is needed here, because without it Swift uses the unwrapped copy.
                    self.activityViewModel = nil
                }
            }
        } else {
            // No goal yet: show Onboarding.
            // When the user taps "Start Learning", we get the new Goal here.
            OnboardingView { newGoal in
                // Create the ViewModel and save it right away.
                // activityViewModel is no longer nil, so the screen switches to Activity.
                activityViewModel = ActivityViewModel.startNew(goal: newGoal)
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
