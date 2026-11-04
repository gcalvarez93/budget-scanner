//
//  UpdateBudgetUseCase.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/UseCases/UpdateBudgetUseCase.swift
import Foundation

final class UpdateBudgetUseCase {
    private let repository: BudgetRepositoryProtocol

    init(repository: BudgetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws {
        guard !name.isEmpty else { throw Failure.validation(String(localized: "validation_name_empty")) }
        guard limit > 0 else { throw Failure.validation(String(localized: "validation_limit_positive")) }
        try await repository.updateBudget(
            id: id, name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
    }
}
