//
//  DeleteTransactionUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Domain/UseCases/DeleteTransactionUseCase.swift
import Foundation

final class DeleteTransactionUseCase {
    private let repository: TransactionRepositoryProtocol

    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws {
        try await repository.deleteTransaction(id: id)
    }
}
