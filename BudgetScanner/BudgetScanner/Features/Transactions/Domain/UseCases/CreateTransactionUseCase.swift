//
//  CreateTransactionUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/UseCases/CreateTransactionUseCase.swift
import Foundation

final class CreateTransactionUseCase {
    private let repository: TransactionRepositoryProtocol

    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async throws -> String {
        guard amount > 0 else { throw Failure.validation("Amount must be greater than zero") }
        guard !description.isEmpty else { throw Failure.validation("Description cannot be empty") }
        return try await repository.createTransaction(
            budgetId: budgetId, category: category, amount: amount,
            currency: currency, description: description, notes: notes,
            tags: tags, receiptImageUrl: receiptImageUrl,
            merchant: merchant, date: date, isScanned: isScanned
        )
    }
}
