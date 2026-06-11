//
//  BudgetRemoteDataSource.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Data/DataSources/BudgetRemoteDataSource.swift
import Foundation

protocol BudgetRemoteDataSourceProtocol {
    func getBudgets() async throws -> [BudgetModel]
    func getBudgetById(id: String) async throws -> BudgetModel
    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String
    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws
    func deleteBudget(id: String) async throws
    func resetRecurringBudgets() async throws
}

final class BudgetRemoteDataSource: BudgetRemoteDataSourceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient.shared) {
        self.client = client
    }

    func getBudgets() async throws -> [BudgetModel] {
        try await client.get(APIConfig.Budgets.base)
    }

    func getBudgetById(id: String) async throws -> BudgetModel {
        try await client.get(APIConfig.Budgets.byId(id))
    }

    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String {
        let body = CreateBudgetRequest(
            name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
        return try await client.post(APIConfig.Budgets.base, body: body)
    }

    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws {
        let body = CreateBudgetRequest(
            name: name, category: category, limit: limit,
            color: color, currency: currency,
            isRecurring: isRecurring, alertThreshold: alertThreshold
        )
        let _: String = try await client.put(APIConfig.Budgets.byId(id), body: body)
    }

    func deleteBudget(id: String) async throws {
        try await client.delete(APIConfig.Budgets.byId(id))
    }

    func resetRecurringBudgets() async throws {
        struct Empty: Encodable {}
        let _: String = try await client.post(APIConfig.Budgets.resetRecurring, body: Empty())
    }
}
