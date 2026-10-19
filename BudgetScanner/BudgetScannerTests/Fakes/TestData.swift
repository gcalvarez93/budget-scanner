// Path: BudgetScanner/BudgetScannerTests/Fakes/TestData.swift
import Foundation
@testable import BudgetScanner

@MainActor
enum TestData {
    static let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)

    static let user = UserEntity(id: "u1", email: "ana@test.com", name: "Ana", photoUrl: nil)

    static let budget = BudgetEntity(
        id: "b1",
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
        createdAt: referenceDate
    )

    static let transaction = TransactionEntity(
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
        date: referenceDate,
        createdAt: referenceDate,
        isScanned: false
    )

    static let profile = ProfileEntity(
        id: "u1",
        name: "Ana",
        email: "ana@test.com",
        photoUrl: nil,
        language: "es",
        notifications: true
    )

    static let summary = MonthlySummaryEntity(
        year: 2026,
        month: 10,
        totalBudgeted: 300,
        totalSpent: 120,
        totalRemaining: 180,
        overallSpentPercentage: 40,
        budgets: [],
        topCategories: [],
        alertsTriggered: 0
    )

    static let comparison = MonthComparisonEntity(
        currentYear: 2026,
        currentMonth: 10,
        currentMonthSpent: 120,
        previousYear: 2026,
        previousMonth: 9,
        previousMonthSpent: 100,
        difference: 20,
        differencePercentage: 20,
        categoryComparisons: []
    )
}
