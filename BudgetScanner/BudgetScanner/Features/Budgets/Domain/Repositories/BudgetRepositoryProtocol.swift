//
//  BudgetRepositoryProtocol.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Domain/Repositories/BudgetRepositoryProtocol.swift
import Foundation

protocol BudgetRepositoryProtocol {
    func getBudgets() async throws -> [BudgetEntity]
    func getBudgetById(id: String) async throws -> BudgetEntity
    func createBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws -> String
    func updateBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async throws
    func deleteBudget(id: String) async throws
    func resetRecurringBudgets() async throws
}
