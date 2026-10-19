//
//  BudgetsViewModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Budgets/Presentation/ViewModels/BudgetsViewModel.swift
import Foundation
import Observation

enum BudgetsState: Equatable {
    case initial
    case loading
    case loaded([BudgetEntity])
    case error(String)
}

@Observable
final class BudgetsViewModel {
    var state: BudgetsState = .initial
    var showAddBudget = false
    var budgetToEdit: BudgetEntity? = nil

    private let getBudgets: GetBudgetsUseCase
    private let createBudget: CreateBudgetUseCase
    private let updateBudget: UpdateBudgetUseCase
    private let deleteBudget: DeleteBudgetUseCase
    private let resetRecurring: ResetRecurringBudgetsUseCase

    init(
        getBudgets: GetBudgetsUseCase = GetBudgetsUseCase(repository: BudgetRepository()),
        createBudget: CreateBudgetUseCase = CreateBudgetUseCase(repository: BudgetRepository()),
        updateBudget: UpdateBudgetUseCase = UpdateBudgetUseCase(repository: BudgetRepository()),
        deleteBudget: DeleteBudgetUseCase = DeleteBudgetUseCase(repository: BudgetRepository()),
        resetRecurring: ResetRecurringBudgetsUseCase = ResetRecurringBudgetsUseCase(repository: BudgetRepository())
    ) {
        self.getBudgets = getBudgets
        self.createBudget = createBudget
        self.updateBudget = updateBudget
        self.deleteBudget = deleteBudget
        self.resetRecurring = resetRecurring
    }

    func loadBudgets() async {
        state = .loading
        do {
            let budgets = try await getBudgets.execute()
            state = .loaded(budgets)
        } catch {
            AppLogger.error("BudgetsViewModel.loadBudgets", error)
            state = .error(error.localizedDescription)
        }
    }

    func addBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async {
        do {
            _ = try await createBudget.execute(
                name: name, category: category, limit: limit,
                color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
            await loadBudgets()
        } catch {
            AppLogger.error("BudgetsViewModel.addBudget", error)
            state = .error(error.localizedDescription)
        }
    }

    func editBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async {
        do {
            try await updateBudget.execute(
                id: id, name: name, category: category, limit: limit,
                color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
            await loadBudgets()
        } catch {
            AppLogger.error("BudgetsViewModel.editBudget", error)
            state = .error(error.localizedDescription)
        }
    }

    func removeBudget(id: String) async {
        do {
            try await deleteBudget.execute(id: id)
            await loadBudgets()
        } catch {
            AppLogger.error("BudgetsViewModel.removeBudget", error)
            state = .error(error.localizedDescription)
        }
    }

    func resetRecurringBudgets() async {
        do {
            try await resetRecurring.execute()
            await loadBudgets()
        } catch {
            AppLogger.error("BudgetsViewModel.resetRecurringBudgets", error)
            state = .error(error.localizedDescription)
        }
    }
}
