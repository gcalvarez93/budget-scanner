//
//  ThemeManager.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Core/Config/ThemeManager.swift
import SwiftUI
import Observation

@Observable
final class ThemeManager {
    var colorSchemeString: String = UserDefaults.standard.string(forKey: "colorScheme") ?? "system" {
        didSet {
            UserDefaults.standard.set(colorSchemeString, forKey: "colorScheme")
        }
    }

    var colorScheme: ColorScheme? {
        switch colorSchemeString {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }

    func setScheme(_ scheme: String) {
        colorSchemeString = scheme
    }
}
