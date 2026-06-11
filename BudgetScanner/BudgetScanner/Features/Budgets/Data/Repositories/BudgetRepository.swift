//
//  BudgetRepository.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Data/Repositories/BudgetRepository.swift
import Foundation

final class BudgetRepository: BudgetRepositoryProtocol {
    private let dataSource: BudgetRemoteDataSourceProtocol

    init(dataSource: BudgetRemoteDataSourceProtocol = BudgetRemoteDataSource()) {
        self.dataSource = dataSource
    }

    func getBudgets() async throws -> [BudgetEntity] {
        let models = try await dataSource.getBudgets()
        return models.map { $0.toEntity() }
    }

    func getBudgetById(id: String) async throws -> BudgetEntity {
        let model = try await dataSource.getBudgetById(id: id)
        return model.toEntity()
    }

    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String {
        try await dataSource.createBudget(
            name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
    }

    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws {
        try await dataSource.updateBudget(
            id: id, name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
    }

    func deleteBudget(id: String) async throws {
        try await dataSource.deleteBudget(id: id)
    }

    func resetRecurringBudgets() async throws {
        try await dataSource.resetRecurringBudgets()
    }
}
