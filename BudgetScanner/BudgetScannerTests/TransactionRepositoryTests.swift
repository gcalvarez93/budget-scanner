// Path: BudgetScanner/BudgetScannerTests/TransactionRepositoryTests.swift
import Testing
@testable import BudgetScanner

@MainActor
struct TransactionRepositoryTests {
    private let dataSource = FakeTransactionRemoteDataSource()

    private func makeRepository() -> TransactionRepository {
        TransactionRepository(dataSource: dataSource)
    }

    @Test func getTransactionsMapsModelsToEntities() async throws {
        dataSource.transactions = [
            TransactionModel(
                id: "t1",
                budgetId: "b1",
                category: "food",
                amount: 12.5,
                currency: "EUR",
                description: "Menú del día",
                notes: "",
                tags: ["trabajo"],
                receiptImageUrl: nil,
                merchant: "Bar Pepe",
                date: TestData.referenceDate,
                createdAt: TestData.referenceDate,
                isScanned: false
            )
        ]

        let transactions = try await makeRepository().getTransactions(budgetId: "b1")

        #expect(transactions == [TestData.transaction])
        #expect(dataSource.lastBudgetIdFilter == "b1")
    }

    @Test func getTransactionsWithoutBudgetDoesNotFilter() async throws {
        _ = try await makeRepository().getTransactions(budgetId: nil)

        #expect(dataSource.lastBudgetIdFilter == nil)
    }

    @Test func createTransactionBuildsTheRequest() async throws {
        let id = try await makeRepository().createTransaction(
            budgetId: "b1", category: "food", amount: 9.9, currency: "EUR",
            description: "Café", notes: "n", tags: ["a"], receiptImageUrl: nil,
            merchant: "Bar", date: TestData.referenceDate, isScanned: true
        )

        #expect(id == "t-new")
        let request = try #require(dataSource.lastCreateRequest)
        #expect(request.budgetId == "b1")
        #expect(request.amount == 9.9)
        #expect(request.tags == ["a"])
        #expect(request.isScanned)
    }

    @Test func updateTransactionBuildsTheRequest() async throws {
        try await makeRepository().updateTransaction(
            id: "t1", budgetId: "b1", category: "food", amount: 20, currency: "USD",
            description: "Cena", notes: "", tags: [], receiptImageUrl: nil,
            merchant: nil, date: TestData.referenceDate
        )

        let request = try #require(dataSource.lastUpdateRequest)
        #expect(request.amount == 20)
        #expect(request.currency == "USD")
    }

    @Test func dataSourceErrorsPropagate() async {
        dataSource.error = .network("offline")

        await #expect(throws: Failure.network("offline")) {
            _ = try await makeRepository().getTransactions(budgetId: nil)
        }
    }
}
