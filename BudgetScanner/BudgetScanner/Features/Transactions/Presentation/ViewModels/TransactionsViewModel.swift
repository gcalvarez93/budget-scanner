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
        state = .loading
        do {
            let transactions = try await getTransactions.execute(budgetId: budget.id)
            state = .loaded(transactions)
        } catch {
            AppLogger.error("TransactionsViewModel.loadTransactions", error)
            state = .error(error.localizedDescription)
        }
    }

    func addTransaction(category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date, isScanned: Bool) async {
        do {
            _ = try await createTransaction.execute(
                budgetId: budget.id, category: category, amount: amount,
                currency: currency, description: description, notes: notes,
                tags: tags, receiptImageUrl: receiptImageUrl,
                merchant: merchant, date: date, isScanned: isScanned
            )
            await loadTransactions()
        } catch {
            AppLogger.error("TransactionsViewModel.addTransaction", error)
            state = .error(error.localizedDescription)
        }
    }

    func editTransaction(id: String, category: String, amount: Double, currency: String, description: String, notes: String, tags: [String], receiptImageUrl: String?, merchant: String?, date: Date) async {
        do {
            try await updateTransaction.execute(
                id: id, budgetId: budget.id, category: category,
                amount: amount, currency: currency, description: description,
                notes: notes, tags: tags, receiptImageUrl: receiptImageUrl,
                merchant: merchant, date: date
            )
            await loadTransactions()
        } catch {
            AppLogger.error("TransactionsViewModel.editTransaction", error)
            state = .error(error.localizedDescription)
        }
    }

    func removeTransaction(id: String) async {
        do {
            try await deleteTransaction.execute(id: id)
            await loadTransactions()
        } catch {
            AppLogger.error("TransactionsViewModel.removeTransaction", error)
            state = .error(error.localizedDescription)
        }
    }
}
