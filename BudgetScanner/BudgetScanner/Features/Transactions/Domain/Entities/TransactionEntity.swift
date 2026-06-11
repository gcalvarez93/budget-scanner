//
//  TransactionEntity.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/Entities/TransactionEntity.swift
import Foundation

struct TransactionEntity: Equatable, Identifiable {
    let id: String
    let budgetId: String
    let category: String
    let amount: Double
    let currency: String
    let description: String
    let notes: String
    let tags: [String]
    let receiptImageUrl: String?
    let merchant: String?
    let date: Date
    let createdAt: Date
    let isScanned: Bool
}
