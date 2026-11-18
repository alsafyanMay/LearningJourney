//
//  SplashView.swift
//  LearningJourney
//
//  Created by may.mohammed on 06/06/1448 AH.
//
//  What this file does:
//  The animated welcome screen shown when the app opens.
//  The words "learning journey" appear from blurry to clear
//  on a Liquid Glass card, with soft orange and blue lights moving behind it.
//  When the animation ends, it tells ContentView to show the app.
//

import SwiftUI

struct SplashView: View {

    // A closure we call when the animation is finished,
    // so ContentView can hide this screen.
    let onFinish: () -> Void

    // All @State: these only control the animation (what is visible and where).
    // There is no data or logic here, so this screen does not need a ViewModel.
    @State private var isPanelVisible = false
    @State private var isWordVisible = false
    @State private var moveBlobs = false

    // An accessibility setting. If the user turned on "Reduce Motion",
    // we skip the moving animation and show everything at once.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Orange to blue, the same colors as the app icon.
    // Each color keeps more space (stops), so the middle does not look gray.
    private let gradient = LinearGradient(
        stops: [
            .init(color: .orange, location: 0.35),
            .init(color: .cyan, location: 0.65)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        // ZStack: puts views on top of each other (background, lights, then the card).
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            blobs

            Text("learning journey")
                // A handwriting font. relativeTo: it grows or shrinks
                // with the user's text size setting (Dynamic Type).
                .font(.custom("MarkerFelt-Thin", size: 44, relativeTo: .largeTitle))
                .lineLimit(1)
                .minimumScaleFactor(0.7)        // can shrink a little if there is not enough space
                .foregroundStyle(gradient)
                .shadow(color: .orange.opacity(0.5), radius: 8)   // soft glow

                // The words start blurry, small, and invisible, then become clear.
                .blur(radius: isWordVisible ? 0 : 12)
                .scaleEffect(isWordVisible ? 1 : 0.9)
                .opacity(isWordVisible ? 1 : 0)

                // The Liquid Glass card around the words.
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
                .glassEffect(.regular, in: .rect(cornerRadius: 40))

                // The card starts a little small and invisible, then pops in.
                .scaleEffect(isPanelVisible ? 1 : 0.85)
                .opacity(isPanelVisible ? 1 : 0)
                .padding(.horizontal)
        }
        // .task: runs when the screen appears, and supports async/await.
        .task {
            await runAnimation()
        }
    }

    // Two soft blurry circles (orange and blue) that slowly move left and right.
    // The glass card reflects their colors, which makes the glass look alive.
    private var blobs: some View {
        ZStack {
            Circle()
                .fill(.orange)
                .frame(width: 260)
                .blur(radius: 80)
                .offset(x: moveBlobs ? -70 : 70, y: -80)

            Circle()
                .fill(.cyan)
                .frame(width: 260)
                .blur(radius: 80)
                .offset(x: moveBlobs ? 70 : -70, y: 80)
        }
        .opacity(0.8)
    }

    // The animation steps, in order.
    // async: the function can wait between steps without freezing the app.
    // Task.sleep: wait for some time (like Thread.sleep in Java, but it does not block the app).
    private func runAnimation() async {

        // Reduce Motion is on: show everything right away, wait 1 second, then finish.
        if reduceMotion {
            isPanelVisible = true
            isWordVisible = true
            try? await Task.sleep(for: .seconds(1))
            onFinish()
            return
        }

        // Step 1: the lights start moving back and forth forever.
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            moveBlobs = true
        }

        // Step 2: the glass card pops in with a spring.
        withAnimation(.spring(duration: 0.6)) {
            isPanelVisible = true
        }
        try? await Task.sleep(for: .seconds(0.3))

        // Step 3: the words go from blurry to clear.
        withAnimation(.easeOut(duration: 1.4)) {
            isWordVisible = true
        }
        try? await Task.sleep(for: .seconds(2.2))

        // Step 4: tell ContentView we are done.
        onFinish()
    }
}

#Preview {
    SplashView { }
        .preferredColorScheme(.dark)
}
