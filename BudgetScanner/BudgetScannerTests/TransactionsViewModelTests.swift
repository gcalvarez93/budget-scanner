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

    private func makeLoadedViewModel() async -> TransactionsViewModel {
        repository.transactionsResult = .success([TestData.transaction])
        let viewModel = makeViewModel()
        await viewModel.loadTransactions()
        return viewModel
    }

    @discardableResult
    private func addValidTransaction(to viewModel: TransactionsViewModel, amount: Double = 12.5, description: String = "Menú") async -> String? {
        await viewModel.addTransaction(
            category: "food", amount: amount, currency: "EUR", description: description,
            notes: "", tags: [], receiptImageUrl: nil, merchant: nil,
            date: TestData.referenceDate, isScanned: false
        )
    }

    // MARK: - Carga

    @Test func loadTransactionsFiltersByTheCurrentBudget() async {
        repository.transactionsResult = .success([TestData.transaction])
        let viewModel = makeViewModel()

        await viewModel.loadTransactions()

        #expect(viewModel.state == .loaded([TestData.transaction]))
        #expect(repository.lastBudgetIdFilter == "b1")
    }

    @Test func loadTransactionsFailureShowsTheUserMessage() async {
        repository.transactionsResult = .failure(.network("offline"))
        let viewModel = makeViewModel()

        await viewModel.loadTransactions()

        #expect(viewModel.state == .error(Failure.network("offline").userMessage))
    }

    @Test func loadTransactionsFailureDoesNotExposeTheTechnicalDetail() async {
        repository.transactionsResult = .failure(.network("offline"))
        let viewModel = makeViewModel()

        await viewModel.loadTransactions()

        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected an error state")
            return
        }
        #expect(!message.contains("offline"))
    }

    // MARK: - Crear

    @Test func addTransactionReloadsTheListAndReturnsNil() async {
        let viewModel = makeViewModel()

        let message = await addValidTransaction(to: viewModel)

        #expect(message == nil)
        #expect(repository.createCalls == 1)
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func addTransactionWithANonPositiveAmountReturnsTheValidationMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()

        let message = await addValidTransaction(to: viewModel, amount: 0)

        #expect(message == String(localized: "validation_amount_positive"))
        #expect(viewModel.state == .loaded([TestData.transaction]))
        #expect(repository.createCalls == 0)
    }

    @Test func addTransactionWithAnEmptyDescriptionReturnsTheValidationMessage() async {
        let viewModel = await makeLoadedViewModel()

        let message = await addValidTransaction(to: viewModel, description: "")

        #expect(message == String(localized: "validation_description_empty"))
        #expect(viewModel.state == .loaded([TestData.transaction]))
        #expect(repository.createCalls == 0)
    }

    @Test func failedAddTransactionReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.createResult = .failure(.server("HTTP 500"))

        let message = await addValidTransaction(to: viewModel)

        #expect(message == Failure.server("HTTP 500").userMessage)
        #expect(viewModel.state == .loaded([TestData.transaction]))
    }

    // MARK: - Editar

    @Test func editTransactionReloadsTheListAndReturnsNil() async {
        let viewModel = makeViewModel()

        let message = await viewModel.editTransaction(
            id: "t1", category: "food", amount: 20, currency: "EUR", description: "Menú",
            notes: "", tags: [], receiptImageUrl: nil, merchant: nil, date: TestData.referenceDate
        )

        #expect(message == nil)
        #expect(repository.updatedId == "t1")
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func failedEditTransactionReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.updateResult = .failure(.network("offline"))

        let message = await viewModel.editTransaction(
            id: "t1", category: "food", amount: 20, currency: "EUR", description: "Menú",
            notes: "", tags: [], receiptImageUrl: nil, merchant: nil, date: TestData.referenceDate
        )

        #expect(message == Failure.network("offline").userMessage)
        #expect(viewModel.state == .loaded([TestData.transaction]))
    }

    // MARK: - Borrar

    @Test func removeTransactionDeletesAndReloads() async {
        let viewModel = makeViewModel()

        let message = await viewModel.removeTransaction(id: "t1")

        #expect(message == nil)
        #expect(repository.deletedId == "t1")
        #expect(repository.getTransactionsCalls == 1)
    }

    @Test func failedRemoveTransactionReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.deleteResult = .failure(.server("HTTP 404"))

        let message = await viewModel.removeTransaction(id: "t1")

        #expect(message == Failure.server("HTTP 404").userMessage)
        #expect(viewModel.state == .loaded([TestData.transaction]))
    }
}
