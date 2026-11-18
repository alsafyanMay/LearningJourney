//
//  CustomAlert.swift
//  LearningJourney
//
//  What this file does:
//  A dark alert card with a title, a message and two buttons.
//  We draw it ourselves (instead of the system alert) so it matches the Sketch design:
//  the system alert does not let us choose the button colors.
//  Sizes and colors are taken from the Sketch file (Alerts/Dark/Default).
//

import SwiftUI

// A reusable Component. It only draws the card and calls the closures it is given.
struct CustomAlert: View {
    let title: String
    let message: String
    let cancelTitle: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    // The card shape. "continuous" = Sketch "Smooth" corners.
    private let shape = RoundedRectangle(cornerRadius: 34, style: .continuous)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Title and message, 8 points inside the 14 points padding of the card.
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.body.weight(.semibold))   // SF Pro 17 semibold
                    .foregroundStyle(.primary)
                Text(message)
                    .font(.body)                     // SF Pro 17 regular
                    .foregroundStyle(Color(white: 0.6))
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)

            Spacer(minLength: 0)

            // Two buttons of the same width, 8 points apart.
            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(.body.weight(.medium))   // SF Pro 17 medium
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        // #767680 at 24%, from the design.
                        .background(Color(red: 0.463, green: 0.463, blue: 0.502).opacity(0.24), in: .capsule)
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .font(.body.weight(.semibold))   // SF Pro 17 semibold
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        // Orange #FF9230, from the design.
                        .background(Color(red: 1.0, green: 0.573, blue: 0.188), in: .capsule)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(14)
        .frame(width: 300, height: 184)
        .background(Color.appAlertFill, in: shape)
        .overlay(shape.strokeBorder(.primary.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.45), radius: 24, y: 18)
    }
}

#Preview {
    CustomAlert(
        title: "Update goal",
        message: "If you update now, your streak will start over.",
        cancelTitle: "Dismiss",
        confirmTitle: "Update",
        onCancel: { },
        onConfirm: { }
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
    .preferredColorScheme(.dark)
}
