//
//  BudgetModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Data/Models/BudgetModel.swift
import Foundation

struct BudgetModel: Codable {
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

    func toEntity() -> BudgetEntity {
        BudgetEntity(
            id: id,
            name: name,
            category: category,
            limit: limit,
            spent: spent,
            remainingAmount: remainingAmount,
            spentPercentage: spentPercentage,
            color: color,
            currency: currency,
            isRecurring: isRecurring,
            alertThreshold: alertThreshold,
            isAlertTriggered: isAlertTriggered,
            createdAt: createdAt
        )
    }
}

struct CreateBudgetRequest: Encodable {
    let name: String
    let category: String
    let limit: Double
    let color: String
    let currency: String
    let isRecurring: Bool
    let alertThreshold: Int
}
