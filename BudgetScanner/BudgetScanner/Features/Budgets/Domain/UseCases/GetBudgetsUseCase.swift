//
//  GetBudgetsUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/UseCases/GetBudgetsUseCase.swift
import Foundation

final class GetBudgetsUseCase {
    private let repository: BudgetRepositoryProtocol

    init(repository: BudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [BudgetEntity] {
        try await repository.getBudgets()
    }
}
