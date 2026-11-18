//
//  AppColors.swift
//  LearningJourney
//
//  What this file does:
//  Colors that change with the device setting (Light or Dark).
//  The Dark values are the ones from the Sketch design.
//  The Light values are our own, because the design only has Dark.
//

import SwiftUI
import UIKit

extension Color {

    // The gray fill of a button that is already used (Logged as Learned, Freezed for a day).
    static let appMutedFill = dynamic(dark: UIColor(white: 0.11, alpha: 1),
                                      light: UIColor(white: 0.9, alpha: 1))

    // The background of the Learned and Freezed cards.
    static let appCardFill = dynamic(dark: UIColor(white: 0.1, alpha: 0.5),
                                     light: UIColor(white: 0, alpha: 0.05))

    // The background of the alert card.
    static let appAlertFill = dynamic(dark: UIColor(white: 0.1, alpha: 1),
                                      light: UIColor(white: 1, alpha: 1))

    // The dim layer behind the alert.
    static let appOverlay = dynamic(dark: UIColor(white: 0.07, alpha: 0.56),
                                    light: UIColor(white: 0, alpha: 0.3))

    // Builds a color that asks the system which style is on, every time it is drawn.
    private static func dynamic(dark: UIColor, light: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}
