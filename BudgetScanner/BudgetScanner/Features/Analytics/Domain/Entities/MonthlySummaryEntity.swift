//
//  MonthlySummaryEntity..swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Analytics/Domain/Entities/MonthlySummaryEntity.swift
import Foundation

struct MonthlySummaryEntity {
    let year: Int
    let month: Int
    let totalBudgeted: Double
    let totalSpent: Double
    let totalRemaining: Double
    let overallSpentPercentage: Double
    let budgets: [BudgetSummaryItemEntity]
    let topCategories: [CategoryBreakdownEntity]
    let alertsTriggered: Int
}

struct BudgetSummaryItemEntity {
    let budgetId: String
    let name: String
    let category: String
    let color: String
    let limit: Double
    let spent: Double
    let spentPercentage: Double
    let isAlertTriggered: Bool
}

struct CategoryBreakdownEntity {
    let category: String
    let totalSpent: Double
    let transactionCount: Int
    let percentage: Double
}

struct MonthComparisonEntity {
    let currentYear: Int
    let currentMonth: Int
    let currentMonthSpent: Double
    let previousYear: Int
    let previousMonth: Int
    let previousMonthSpent: Double
    let difference: Double
    let differencePercentage: Double
    let categoryComparisons: [CategoryComparisonEntity]
}

struct CategoryComparisonEntity {
    let category: String
    let currentSpent: Double
    let previousSpent: Double
    let difference: Double
}
