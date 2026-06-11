//
//  DeleteBudgetUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/UseCases/DeleteBudgetUseCase.swift
import Foundation

final class DeleteBudgetUseCase {
    private let repository: BudgetRepositoryProtocol

    init(repository: BudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws {
        try await repository.deleteBudget(id: id)
    }
}
