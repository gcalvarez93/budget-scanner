//
//  GetTransactionsUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/UseCases/GetTransactionsUseCase.swift
import Foundation

final class GetTransactionsUseCase {
    private let repository: TransactionRepositoryProtocol

    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(budgetId: String? = nil) async throws -> [TransactionEntity] {
        try await repository.getTransactions(budgetId: budgetId)
    }
}
