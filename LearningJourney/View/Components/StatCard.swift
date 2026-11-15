//
//  StatCard.swift
//  LearningJourney
//
//  Created by may.mohammed on 05/06/1448 AH.
//
//  What this file does:
//  A small glass card that shows an icon, a number of days, and a title,
//  for example "3 days Learned".
//  Used twice on the Activity screen (Learned and Freezed)
//  and again on the Calendar screen.
//

import SwiftUI

// A reusable Component. It only shows what it is given.
// All properties are let: the card never changes them, it just displays them.
struct StatCard: View {

    // The SF Symbol name, for example "flame.fill" or "snowflake".
    let icon: String

    // The icon color.
    let color: Color

    // The number of days.
    let count: Int

    // The label under the number, for example "Learned".
    let title: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)

            // String interpolation: \( ) puts a value inside the text,
            // for example "3 days" or "1 day".
            Text("\(count) \(unit)")
                .fontWeight(.semibold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)   // both cards take the same width
        .padding(.vertical, 12)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))   // Liquid Glass card
    }

    // "day" when the number is 1, "days" for any other number.
    // The ternary operator ( condition ? a : b ) works the same as in Java.
    private var unit: String {
        count == 1 ? "day" : "days"
    }
}

#Preview {
    StatCard(icon: "flame.fill", color: .orange, count: 3, title: "Learned")
        .preferredColorScheme(.dark)
}
