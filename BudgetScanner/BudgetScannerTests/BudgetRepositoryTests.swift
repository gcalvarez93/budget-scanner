// Path: BudgetScanner/BudgetScannerTests/BudgetRepositoryTests.swift
import Testing
@testable import BudgetScanner

@MainActor
struct BudgetRepositoryTests {
    private let dataSource = FakeBudgetRemoteDataSource()

    private func makeRepository() -> BudgetRepository {
        BudgetRepository(dataSource: dataSource)
    }

    private func model(id: String = "b1") -> BudgetModel {
        BudgetModel(
            id: id,
            name: "Comida",
            category: "food",
            limit: 300,
            spent: 120,
            remainingAmount: 180,
            spentPercentage: 40,
            color: "#7C3AED",
            currency: "EUR",
            isRecurring: true,
            alertThreshold: 80,
            isAlertTriggered: false,
            createdAt: TestData.referenceDate
        )
    }

    @Test func getBudgetsMapsModelsToEntities() async throws {
        dataSource.budgets = [model()]

        let budgets = try await makeRepository().getBudgets()

        #expect(budgets == [TestData.budget])
    }

    @Test func getBudgetByIdReturnsTheMatchingBudget() async throws {
        dataSource.budgets = [model(id: "b1"), model(id: "b2")]

        let budget = try await makeRepository().getBudgetById(id: "b2")

        #expect(budget.id == "b2")
    }

    @Test func dataSourceErrorsPropagate() async {
        dataSource.error = .server("HTTP 500")

        await #expect(throws: Failure.server("HTTP 500")) {
            _ = try await makeRepository().getBudgets()
        }
    }
}
