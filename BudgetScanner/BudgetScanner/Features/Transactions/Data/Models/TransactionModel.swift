//
//  TransactionModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Data/Models/TransactionModel.swift
import Foundation

struct TransactionModel: Codable {
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

    func toEntity() -> TransactionEntity {
        TransactionEntity(
            id: id, budgetId: budgetId, category: category,
            amount: amount, currency: currency,
            description: description, notes: notes, tags: tags,
            receiptImageUrl: receiptImageUrl, merchant: merchant,
            date: date, createdAt: createdAt, isScanned: isScanned
        )
    }
}

struct CreateTransactionRequest: Encodable {
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
    let isScanned: Bool
}

struct UpdateTransactionRequest: Encodable {
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
}
