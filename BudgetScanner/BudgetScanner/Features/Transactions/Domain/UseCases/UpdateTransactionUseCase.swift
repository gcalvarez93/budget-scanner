//
//  UpdateTransactionUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/UseCases/UpdateTransactionUseCase.swift
import Foundation

final class UpdateTransactionUseCase {
    private let repository: TransactionRepositoryProtocol

    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String, budgetId: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async throws {
        guard amount > 0 else { throw Failure.network("Amount must be greater than zero") }
        try await repository.updateTransaction(
            id: id, budgetId: budgetId, category: category,
            amount: amount, currency: currency, description: description,
            notes: notes, tags: tags, receiptImageUrl: receiptImageUrl,
            merchant: merchant, date: date
        )
    }
}
