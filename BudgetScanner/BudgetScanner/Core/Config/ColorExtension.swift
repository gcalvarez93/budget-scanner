//
//  ColorExtension.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Core/Config/ColorExtension.swift
import SwiftUI

extension Color {
    static let bgPrimary      = Color("BgPrimary")
    static let bgSecondary    = Color("BgSecondary")
    static let bgCard         = Color("BgCard")
    static let textPrimary    = Color("TextPrimary")
    static let textSecondary  = Color("TextSecondary")
    static let emerald        = Color(hex: "#10B981")
    static let warningColor   = Color(hex: "#F59E0B")
    static let errorColor     = Color(hex: "#EF4444")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: 1)
    }
}
