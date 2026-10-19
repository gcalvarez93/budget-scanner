//
//  CreateBudgetUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/UseCases/CreateBudgetUseCase.swift
import Foundation

final class CreateBudgetUseCase {
    private let repository: BudgetRepositoryProtocol

    init(repository: BudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String {
        guard !name.isEmpty else { throw Failure.validation("Name cannot be empty") }
        guard limit > 0 else { throw Failure.validation("Limit must be greater than zero") }
        return try await repository.createBudget(
            name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
    }
}
