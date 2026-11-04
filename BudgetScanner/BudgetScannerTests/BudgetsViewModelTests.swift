// Path: BudgetScanner/BudgetScannerTests/BudgetsViewModelTests.swift
import Foundation
import Testing
@testable import BudgetScanner

@MainActor
struct BudgetsViewModelTests {
    private let repository = FakeBudgetRepository()

    private func makeViewModel() -> BudgetsViewModel {
        BudgetsViewModel(
            getBudgets: GetBudgetsUseCase(repository: repository),
            createBudget: CreateBudgetUseCase(repository: repository),
            updateBudget: UpdateBudgetUseCase(repository: repository),
            deleteBudget: DeleteBudgetUseCase(repository: repository),
            resetRecurring: ResetRecurringBudgetsUseCase(repository: repository)
        )
    }

    private func makeLoadedViewModel() async -> BudgetsViewModel {
        repository.budgetsResult = .success([TestData.budget])
        let viewModel = makeViewModel()
        await viewModel.loadBudgets()
        return viewModel
    }

    // MARK: - Carga

    @Test func loadBudgetsExposesTheLoadedBudgets() async {
        repository.budgetsResult = .success([TestData.budget])
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    @Test func loadBudgetsFailureShowsTheUserMessage() async {
        repository.budgetsResult = .failure(.server("HTTP 500"))
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .error(Failure.server("HTTP 500").userMessage))
    }

    @Test func loadBudgetsFailureDoesNotExposeTheTechnicalDetail() async {
        repository.budgetsResult = .failure(.server("HTTP 500"))
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected an error state")
            return
        }
        #expect(!message.contains("HTTP 500"))
    }

    @Test func aCancelledLoadDoesNotShowAnError() async {
        repository.budgetsError = CancellationError()
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .initial)
    }

    @Test func aCancelledReloadKeepsTheLoadedBudgets() async {
        let viewModel = await makeLoadedViewModel()
        repository.budgetsError = CancellationError()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    // MARK: - Crear

    @Test func addBudgetReloadsTheListAndReturnsNil() async {
        let viewModel = makeViewModel()

        let message = await viewModel.addBudget(
            name: "Ocio", category: "fun", limit: 100, color: "#FF0000",
            currency: "EUR", isRecurring: false, alertThreshold: 80
        )

        #expect(message == nil)
        #expect(repository.createCalls == 1)
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func addBudgetWithAnInvalidLimitReturnsTheValidationMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()

        let message = await viewModel.addBudget(
            name: "Ocio", category: "fun", limit: 0, color: "#FF0000",
            currency: "EUR", isRecurring: false, alertThreshold: 80
        )

        #expect(message == String(localized: "validation_limit_positive"))
        #expect(viewModel.state == .loaded([TestData.budget]))
        #expect(repository.createCalls == 0)
    }

    @Test func failedAddBudgetReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.createResult = .failure(.server("HTTP 500"))

        let message = await viewModel.addBudget(
            name: "Ocio", category: "fun", limit: 100, color: "#FF0000",
            currency: "EUR", isRecurring: false, alertThreshold: 80
        )

        #expect(message == Failure.server("HTTP 500").userMessage)
        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    // MARK: - Editar

    @Test func editBudgetReloadsTheListAndReturnsNil() async {
        let viewModel = makeViewModel()

        let message = await viewModel.editBudget(
            id: "b1", name: "Comida", category: "food", limit: 350, color: "#7C3AED",
            currency: "EUR", isRecurring: true, alertThreshold: 90
        )

        #expect(message == nil)
        #expect(repository.updatedId == "b1")
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func failedEditBudgetReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.updateResult = .failure(.network("offline"))

        let message = await viewModel.editBudget(
            id: "b1", name: "Comida", category: "food", limit: 350, color: "#7C3AED",
            currency: "EUR", isRecurring: true, alertThreshold: 90
        )

        #expect(message == Failure.network("offline").userMessage)
        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    // MARK: - Borrar

    @Test func removeBudgetDeletesAndReloads() async {
        let viewModel = makeViewModel()

        let message = await viewModel.removeBudget(id: "b1")

        #expect(message == nil)
        #expect(repository.deletedId == "b1")
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func failedRemoveBudgetReturnsTheUserMessageAndKeepsTheList() async {
        let viewModel = await makeLoadedViewModel()
        repository.deleteResult = .failure(.server("HTTP 404"))

        let message = await viewModel.removeBudget(id: "b1")

        #expect(message == Failure.server("HTTP 404").userMessage)
        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    // MARK: - Reiniciar recurrentes

    @Test func resetRecurringBudgetsReloadsTheList() async {
        let viewModel = makeViewModel()

        let message = await viewModel.resetRecurringBudgets()

        #expect(message == nil)
        #expect(repository.resetCalls == 1)
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func failedResetRecurringBudgetsReturnsTheUserMessage() async {
        let viewModel = await makeLoadedViewModel()
        repository.resetResult = .failure(.server("HTTP 500"))

        let message = await viewModel.resetRecurringBudgets()

        #expect(message == Failure.server("HTTP 500").userMessage)
        #expect(viewModel.state == .loaded([TestData.budget]))
    }
}
