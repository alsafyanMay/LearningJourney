//
//  StatCard.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  A small dark glass card that shows an icon, a number of days, and a title,
//  for example "3 days Learned". Used twice on the Activity screen.
//  The values come from the design (Apple's Liquid Glass "Regular - Large" style).
//

import SwiftUI

// A reusable Component. It only shows what it is given.
struct StatCard: View {
    let icon: String    // the SF Symbol name
    let color: Color    // the icon color
    let count: Int      // the number of days
    let title: String   // for example "Learned"

    // The card shape, used three times below. "continuous" = Sketch "Smooth" corners.
    private let shape = RoundedRectangle(cornerRadius: 34, style: .continuous)

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(color)
                .frame(height: 25)

            // The number and the title sit close together, like the design.
            VStack(spacing: 4) {
                // .callout = SF Pro 16 (Semibold in the design).
                Text("\(count) \(unit)")
                    .font(.callout.weight(.semibold))

                // .caption = SF Pro 12.
                Text(title)
                    .font(.caption)
            }
        }
        .foregroundStyle(.primary)
        .padding(.top, 14)            // top padding from the design
        .frame(maxWidth: .infinity)   // both cards take the same width
        .frame(height: 102, alignment: .top)   // height from the design
        // Fill from the design: #1A1A1A at 50%.
        .background(Color.appCardFill, in: shape)
        // A soft glowing edge all around, like the inner shadows in the design.
        .overlay(
            shape
                .strokeBorder(.primary.opacity(0.15), lineWidth: 1)
                .blur(radius: 1)   // makes the edge soft instead of sharp
        )
        // Cut anything outside the shape, so the glow stays inside the card.
        .clipShape(shape)
    }

    // "day" when the number is 1, "days" for any other number.
    private var unit: String {
        count == 1 ? "day" : "days"
    }
}

#Preview {
    StatCard(icon: "flame.fill", color: .orange, count: 3, title: "Learned")
        .padding()
        .preferredColorScheme(.dark)
}
