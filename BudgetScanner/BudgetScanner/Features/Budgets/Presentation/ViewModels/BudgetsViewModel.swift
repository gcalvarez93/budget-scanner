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
        let previous = state
        state = .loading
        do {
            let budgets = try await getBudgets.execute()
            state = .loaded(budgets)
        } catch {
            if error.isCancellation {
                restoreAfterCancellation(previous)
                return
            }
            AppLogger.error("BudgetsViewModel.loadBudgets", error)
            state = .error(error.userFacingMessage)
        }
    }

    // Las operaciones de escritura devuelven `nil` si salieron bien o el mensaje para el usuario
    // si fallaron. Un fallo no sustituye la lista ya cargada: la pantalla decide cómo avisar.

    @discardableResult
    func addBudget(name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async -> String? {
        do {
            _ = try await createBudget.execute(
                name: name, category: category, limit: limit,
                color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
        } catch {
            return failureMessage(for: error, context: "BudgetsViewModel.addBudget")
        }
        await loadBudgets()
        return nil
    }

    @discardableResult
    func editBudget(id: String, name: String, category: String, limit: Double, color: String, currency: String, isRecurring: Bool, alertThreshold: Int) async -> String? {
        do {
            try await updateBudget.execute(
                id: id, name: name, category: category, limit: limit,
                color: color, currency: currency,
                isRecurring: isRecurring, alertThreshold: alertThreshold
            )
        } catch {
            return failureMessage(for: error, context: "BudgetsViewModel.editBudget")
        }
        await loadBudgets()
        return nil
    }

    @discardableResult
    func removeBudget(id: String) async -> String? {
        do {
            try await deleteBudget.execute(id: id)
        } catch {
            return failureMessage(for: error, context: "BudgetsViewModel.removeBudget")
        }
        await loadBudgets()
        return nil
    }

    @discardableResult
    func resetRecurringBudgets() async -> String? {
        do {
            try await resetRecurring.execute()
        } catch {
            return failureMessage(for: error, context: "BudgetsViewModel.resetRecurringBudgets")
        }
        await loadBudgets()
        return nil
    }

    /// Registra el fallo y devuelve el mensaje para el usuario. Una cancelación no es un fallo: `nil`.
    private func failureMessage(for error: Error, context: String) -> String? {
        if error.isCancellation { return nil }
        AppLogger.error(context, error)
        return error.userFacingMessage
    }

    private func restoreAfterCancellation(_ previous: BudgetsState) {
        if case .loading = previous {
            state = .initial
        } else {
            state = previous
        }
    }
}
