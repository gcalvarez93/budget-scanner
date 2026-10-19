// Path: BudgetScanner/BudgetScannerTests/BudgetsViewModelTests.swift
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

    @Test func loadBudgetsExposesTheLoadedBudgets() async {
        repository.budgetsResult = .success([TestData.budget])
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .loaded([TestData.budget]))
    }

    @Test func loadBudgetsFailureShowsTheMessage() async {
        repository.budgetsResult = .failure(.server("HTTP 500"))
        let viewModel = makeViewModel()

        await viewModel.loadBudgets()

        #expect(viewModel.state == .error("Server error: HTTP 500"))
    }

    @Test func addBudgetReloadsTheList() async {
        let viewModel = makeViewModel()

        await viewModel.addBudget(
            name: "Ocio", category: "fun", limit: 100, color: "#FF0000",
            currency: "EUR", isRecurring: false, alertThreshold: 80
        )

        #expect(repository.createCalls == 1)
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func addBudgetWithAnInvalidLimitShowsTheValidationMessageAndDoesNotCallTheRepository() async {
        let viewModel = makeViewModel()

        await viewModel.addBudget(
            name: "Ocio", category: "fun", limit: 0, color: "#FF0000",
            currency: "EUR", isRecurring: false, alertThreshold: 80
        )

        #expect(viewModel.state == .error("Limit must be greater than zero"))
        #expect(repository.createCalls == 0)
    }

    @Test func editBudgetReloadsTheList() async {
        let viewModel = makeViewModel()

        await viewModel.editBudget(
            id: "b1", name: "Comida", category: "food", limit: 350, color: "#7C3AED",
            currency: "EUR", isRecurring: true, alertThreshold: 90
        )

        #expect(repository.updatedId == "b1")
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func removeBudgetDeletesAndReloads() async {
        let viewModel = makeViewModel()

        await viewModel.removeBudget(id: "b1")

        #expect(repository.deletedId == "b1")
        #expect(repository.getBudgetsCalls == 1)
    }

    @Test func removeBudgetFailureShowsTheMessage() async {
        repository.deleteResult = .failure(.server("HTTP 404"))
        let viewModel = makeViewModel()

        await viewModel.removeBudget(id: "b1")

        #expect(viewModel.state == .error("Server error: HTTP 404"))
    }

    @Test func resetRecurringBudgetsReloadsTheList() async {
        let viewModel = makeViewModel()

        await viewModel.resetRecurringBudgets()

        #expect(repository.resetCalls == 1)
        #expect(repository.getBudgetsCalls == 1)
    }
}
