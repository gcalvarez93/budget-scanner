//
//  BudgetEntity.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/Entities/BudgetEntity.swift
import Foundation

struct BudgetEntity: Equatable, Identifiable {
    let id: String
    let name: String
    let category: String
    let limit: Double
    let spent: Double
    let remainingAmount: Double
    let spentPercentage: Double
    let color: String
    let currency: String
    let isRecurring: Bool
    let alertThreshold: Int
    let isAlertTriggered: Bool
    let createdAt: Date
}
