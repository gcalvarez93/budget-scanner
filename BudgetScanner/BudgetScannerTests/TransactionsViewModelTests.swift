// Path: BudgetScanner/BudgetScannerTests/TransactionsViewModelTests.swift
import Foundation
import Testing
@testable import BudgetScanner

@MainActor
struct TransactionsViewModelTests {
    private let repository = FakeTransactionRepository()

    private func makeViewModel() -> TransactionsViewModel {
        TransactionsViewModel(
            budget: TestData.budget,
            getTransactions: GetTransactionsUseCase(repository: repository),
            createTransaction: CreateTransactionUseCase(repository: repository),
            updateTransaction: UpdateTransactionUseCase(repository: repository),
            deleteTransaction: DeleteTransactionUseCase(repository: repository)
        )
    }

    private func addValidTransaction(to viewModel: TransactionsViewModel, amount: Double = 12.5, description: String = "Menú") async {
        await viewModel.addTransaction(
            category: "food", amount: amount, currency: "EUR", description: description,
            notes: "", tags: [], receiptImageUrl: nil, merchant: nil,
            date: TestData.referenceDate, isScanned: false
        )
    }

    @Test func loadTransactionsFiltersByTheCurrentBudget() async {
        repository.transactionsResult = .success([TestData.transaction])
        let viewModel = makeViewModel()

        await viewModel.loadTransactions()

        #expect(viewModel.state == .loaded([TestData.transaction]))
        #expect(repository.lastBudgetIdFilter == "b1")
    }

    @Test func loadTransactionsFailureShowsTheMessage() async {
        repository.transactionsResult = .failure(.network("offline"))
        let viewModel = makeViewModel()

        await viewModel.loadTransactions()

        #expect(viewModel.state == .error("Network error: offline"))
    }

    @Test func addTransactionReloadsTheList() async {
        let viewModel = makeViewModel()

        await addValidTransaction(to: viewModel)

        #expect(repository.createCalls == 1)
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func addTransactionWithANonPositiveAmountShowsTheValidationMessage() async {
        let viewModel = makeViewModel()

        await addValidTransaction(to: viewModel, amount: 0)

        #expect(viewModel.state == .error("Amount must be greater than zero"))
        #expect(repository.createCalls == 0)
    }

    @Test func addTransactionWithAnEmptyDescriptionShowsTheValidationMessage() async {
        let viewModel = makeViewModel()

        await addValidTransaction(to: viewModel, description: "")

        #expect(viewModel.state == .error("Description cannot be empty"))
        #expect(repository.createCalls == 0)
    }

    @Test func editTransactionReloadsTheList() async {
        let viewModel = makeViewModel()

        await viewModel.editTransaction(
            id: "t1", category: "food", amount: 20, currency: "EUR", description: "Menú",
            notes: "", tags: [], receiptImageUrl: nil, merchant: nil, date: TestData.referenceDate
        )

        #expect(repository.updatedId == "t1")
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func removeTransactionDeletesAndReloads() async {
        let viewModel = makeViewModel()

        await viewModel.removeTransaction(id: "t1")

        #expect(repository.deletedId == "t1")
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func removeTransactionFailureShowsTheMessage() async {
        repository.deleteResult = .failure(.server("HTTP 404"))
        let viewModel = makeViewModel()

        await viewModel.removeTransaction(id: "t1")

        #expect(viewModel.state == .error("Server error: HTTP 404"))
    }
}
