//
//  TransactionRepositoryProtocol.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/Repositories/TransactionRepositoryProtocol.swift
import Foundation

protocol TransactionRepositoryProtocol {
    func getTransactions(budgetId: String?) async throws -> [TransactionEntity]
    func getTransactionById(id: String) async throws -> TransactionEntity
    func createTransaction(budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async throws -> String
    func updateTransaction(id: String, budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async throws
    func deleteTransaction(id: String) async throws
}
