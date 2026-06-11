//
//  TransactionRepository.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Data/Repositories/TransactionRepository.swift
import Foundation

final class TransactionRepository: TransactionRepositoryProtocol {
    private let dataSource: TransactionRemoteDataSourceProtocol

    init(dataSource: TransactionRemoteDataSourceProtocol = TransactionRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func getTransactions(budgetId: String?) async throws -> [TransactionEntity] {
        let models = try await dataSource.getTransactions(budgetId: budgetId)
        return models.map { $0.toEntity() }
    }

    func getTransactionById(id: String) async throws -> TransactionEntity {
        let model = try await dataSource.getTransactionById(id: id)
        return model.toEntity()
    }

    func createTransaction(budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async throws -> String {
        let request = CreateTransactionRequest(
            budgetId: budgetId, category: category, amount: amount,
            currency: currency, description: description, notes: notes,
            tags: tags, receiptImageUrl: receiptImageUrl,
            merchant: merchant, date: date, isScanned: isScanned
        )
        return try await dataSource.createTransaction(request)
    }

    func updateTransaction(id: String, budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async throws {
        let request = UpdateTransactionRequest(
            budgetId: budgetId, category: category, amount: amount,
            currency: currency, description: description, notes: notes,
            tags: tags, receiptImageUrl: receiptImageUrl,
            merchant: merchant, date: date
        )
        try await dataSource.updateTransaction(id: id, request: request)
    }

    func deleteTransaction(id: String) async throws {
        try await dataSource.deleteTransaction(id: id)
    }
}
