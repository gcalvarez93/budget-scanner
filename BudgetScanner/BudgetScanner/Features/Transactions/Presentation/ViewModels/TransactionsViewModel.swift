//
//  TransactionsViewModel.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Presentation/ViewModels/TransactionsViewModel.swift
import Foundation
import Observation

enum TransactionsState: Equatable {
    case initial
    case loading
    case loaded([TransactionEntity])
    case error(String)
}

@Observable
final class TransactionsViewModel {
    var state: TransactionsState = .initial
    var showAddTransaction = false
    var transactionToEdit: TransactionEntity? = nil

    let budget: BudgetEntity

    private let getTransactions: GetTransactionsUseCase
    private let createTransaction: CreateTransactionUseCase
    private let updateTransaction: UpdateTransactionUseCase
    private let deleteTransaction: DeleteTransactionUseCase

    init(
        budget: BudgetEntity,
        getTransactions: GetTransactionsUseCase = GetTransactionsUseCase(repository: TransactionRepository()),
        createTransaction: CreateTransactionUseCase = CreateTransactionUseCase(repository: TransactionRepository()),
        updateTransaction: UpdateTransactionUseCase = UpdateTransactionUseCase(repository: TransactionRepository()),
        deleteTransaction: DeleteTransactionUseCase = DeleteTransactionUseCase(repository: TransactionRepository())
    ) {
        self.budget = budget
        self.getTransactions = getTransactions
        self.createTransaction = createTransaction
        self.updateTransaction = updateTransaction
        self.deleteTransaction = deleteTransaction
    }

    func loadTransactions() async {
        let previous = state
        state = .loading
        do {
            let transactions = try await getTransactions.execute(budgetId: budget.id)
            state = .loaded(transactions)
        } catch {
            if error.isCancellation {
                restoreAfterCancellation(previous)
                return
            }
            AppLogger.error("TransactionsViewModel.loadTransactions", error)
            state = .error(error.userFacingMessage)
        }
    }

    // Las operaciones de escritura devuelven `nil` si salieron bien o el mensaje para el usuario
    // si fallaron. Un fallo no sustituye la lista ya cargada: la pantalla decide cómo avisar.

    @discardableResult
    func addTransaction(category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async -> String? {
        do {
            _ = try await createTransaction.execute(
                budgetId: budget.id, category: category, amount: amount,
                currency: currency, description: description, notes: notes,
                tags: tags, receiptImageUrl: receiptImageUrl,
                merchant: merchant, date: date, isScanned: isScanned
            )
        } catch {
            return failureMessage(for: error, context: "TransactionsViewModel.addTransaction")
        }
        await loadTransactions()
        return nil
    }

    @discardableResult
    func editTransaction(id: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async -> String? {
        do {
            try await updateTransaction.execute(
                id: id, budgetId: budget.id, category: category,
                amount: amount, currency: currency, description: description,
                notes: notes, tags: tags, receiptImageUrl: receiptImageUrl,
                merchant: merchant, date: date
            )
        } catch {
            return failureMessage(for: error, context: "TransactionsViewModel.editTransaction")
        }
        await loadTransactions()
        return nil
    }

    @discardableResult
    func removeTransaction(id: String) async -> String? {
        do {
            try await deleteTransaction.execute(id: id)
        } catch {
            return failureMessage(for: error, context: "TransactionsViewModel.removeTransaction")
        }
        await loadTransactions()
        return nil
    }

    /// Registra el fallo y devuelve el mensaje para el usuario. Una cancelación no es un fallo: `nil`.
    private func failureMessage(for error: Error, context: String) -> String? {
        if error.isCancellation { return nil }
        AppLogger.error(context, error)
        return error.userFacingMessage
    }

    private func restoreAfterCancellation(_ previous: TransactionsState) {
        if case .loading = previous {
            state = .initial
        } else {
            state = previous
        }
    }
}
