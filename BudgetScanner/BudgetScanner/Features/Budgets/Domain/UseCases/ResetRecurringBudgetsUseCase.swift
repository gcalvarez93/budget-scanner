//
//  ResetRecurringBudgetsUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/UseCases/ResetRecurringBudgetsUseCase.swift
import Foundation

final class ResetRecurringBudgetsUseCase {
    private let repository: BudgetRepositoryProtocol

    init(repository: BudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.resetRecurringBudgets()
    }
}
