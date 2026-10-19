// Path: BudgetScanner/BudgetScannerTests/Fakes/FakeDataSources.swift
import Foundation
@testable import BudgetScanner

@MainActor
final class FakeBudgetRemoteDataSource: BudgetRemoteDataSourceProtocol {
    var budgets: [BudgetModel] = []
    var error: Failure?

    func getBudgets() async throws -> [BudgetModel] {
        if let error { throw error }
        return budgets
    }

    func getBudgetById(id: String) async throws -> BudgetModel {
        if let error { throw error }
        guard let model = budgets.first(where: { $0.id == id }) else {
            throw Failure.server("HTTP 404")
        }
        return model
    }

    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String {
        if let error { throw error }
        return "b-new"
    }

    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws {
        if let error { throw error }
    }

    func deleteBudget(id: String) async throws {
        if let error { throw error }
    }

    func resetRecurringBudgets() async throws {
        if let error { throw error }
    }
}

@MainActor
final class FakeTransactionRemoteDataSource: TransactionRemoteDataSourceProtocol {
    var transactions: [TransactionModel] = []
    var error: Failure?

    private(set) var lastBudgetIdFilter: String?
    private(set) var lastCreateRequest: CreateTransactionRequest?
    private(set) var lastUpdateRequest: UpdateTransactionRequest?

    func getTransactions(budgetId: String?) async throws -> [TransactionModel] {
        if let error { throw error }
        lastBudgetIdFilter = budgetId
        return transactions
    }

    func getTransactionById(id: String) async throws -> TransactionModel {
        if let error { throw error }
        guard let model = transactions.first(where: { $0.id == id }) else {
            throw Failure.server("HTTP 404")
        }
        return model
    }

    func createTransaction(_ request: CreateTransactionRequest) async throws -> String {
        if let error { throw error }
        lastCreateRequest = request
        return "t-new"
    }

    func updateTransaction(id: String, request: UpdateTransactionRequest) async throws {
        if let error { throw error }
        lastUpdateRequest = request
    }

    func deleteTransaction(id: String) async throws {
        if let error { throw error }
    }
}
